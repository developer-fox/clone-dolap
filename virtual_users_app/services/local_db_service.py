
import sqlite3
import sys
import random
from model.user_model import UserModel

class localDbService:
  def __init__(self): 
    self.connection = self.initAndConnectDb()
    self.cursor = self.connection.cursor()
    
  # connection method is create a .db file and required tables 
  def initAndConnectDb(self): # -> connection object
    try:
      connection = sqlite3.connect("./local_db.db")
      connection.execute('''CREATE TABLE IF NOT EXISTS USERS (
                        id INTEGER PRIMARY KEY,
                        is_logined BOOLEAN DEFAULT FALSE NOT NULL,
                        username TEXT NOT NULL,
                        email TEXT NOT NULL,
                        password TEXT NOT NULL,
                        x_access_key TEXT,
                        x_refresh_key TEXT,
                        websocket_access_key TEXT,
                        websocket_refresh_key TEXT
                        );''') 
      return connection
    except:
      print('An exception occurred: {}'.format(sys.exc_info()[0]))
  
  def saveNewUserWithoutKeys(self,username: str,email: str,password: str):
    try:
      self.cursor.execute('INSERT INTO USERS(username,email,password) VALUES(?,?,?);',[username,email,password])
      self.connection.commit()
    except Error as error:
      print('An exception occurred: {}'.format(error))
      
  def saveNewUser(self,user: UserModel):
    try:
      self.cursor.execute('INSERT INTO USERS(username,email,password,x_access_key,x_refresh_key,websocket_access_key,websocket_refresh_key) VALUES(?,?,?,?,?,?,?);', (str(user.username),str(user.email),str(user.password), str(user.x_access_key), str(user.x_refresh_key), user.websocket_access_key, user.websocket_refresh_key))
      self.connection.commit()
    except Exception as error:
      print('An exception occurred: {}'.format(error))

  def getUserInformations(self,user: UserModel):
    try:
      self.cursor.execute("SELECT * FROM USERS WHERE username=? AND email=?",(user.username, user.email))
      userInDb = self.cursor.fetchall()[0]
      fetchedUser = UserModel(userInDb[1], userInDb[2], userInDb[3], userInDb[4], userInDb[5], userInDb[6], userInDb[7])
      fetchedUser.addLocalId(userInDb[0])
      return fetchedUser
    except Exception as error:
      print('An exception occurred:' + str(error))
    
  def updateUserJwtKey(self,user: UserModel, newJwtKey: str):
    self.cursor.execute("Update USERS set x_access_key = ? WHERE username = ? AND email= ?",(newJwtKey,user.username, user.email))
    self.connection.commit()
    user.setxAccesKey(newJwtKey)
    return user
  
  def getRandomUserInformationForLogin(self):
    findResult = self.cursor.execute("select * from USERS WHERE is_logined= false").fetchall()
    countOfNotLoginedUsers = len(findResult)
    randomIndex = random.randint(0, countOfNotLoginedUsers-1)
    selectedUser = findResult[randomIndex]
    return {"username": selectedUser[2], "email": selectedUser[3], "password": selectedUser[4], "local_id": selectedUser[0]}
  
  def setUserLoginedInfo(self, user: UserModel):
    self.cursor.execute("UPDATE USERS SET is_logined= true, x_access_key= ?, x_refresh_key= ?, websocket_access_key= ?, websocket_refresh_key= ? WHERE id=?",(user.x_access_key, user.x_refresh_key,user.websocket_access_key, user.websocket_refresh_key,  user.local_id))
    self.connection.commit()

  def allUsersLogout(self):
    self.cursor.execute("UPDATE USERS SET is_logined = false WHERE is_logined= true")
    self.connection.commit()

  def customUserLogout(self, user: UserModel):
    self.cursor.execute("UPDATE USERS SET is_logined = false WHERE id= ?",(user.local_id,))
    self.connection.commit()
    
  def closeConnection(self):
    self.connection.close()
    


localDbInstance = localDbService()