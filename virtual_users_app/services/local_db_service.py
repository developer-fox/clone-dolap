
import sqlite3
import sys
import random
from model.user_model import UserModel
from model.local_notice_model import LocalNotice

class localDbService:
  def __init__(self): 
    self.connection = self.initAndConnectDb()
    self.cursor = self.connection.cursor()
    
  # connection method is create a .db file and required tables 
  def initAndConnectDb(self): # -> connection object
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
      connection.execute('''CREATE TABLE IF NOT EXISTS NOTICES (
                        id INTEGER PRIMARY KEY,
                        url TEXT NOT NULL
                        );''') 
      connection.execute('''CREATE TABLE IF NOT EXISTS NOTICE_LINKS (
                        id INTEGER PRIMARY KEY,
                        top_category TEXT NOT NULL,
                        url TEXT NOT NULL
                        );''') 
      connection.execute('''CREATE TABLE IF NOT EXISTS CONFIG (
                        id INTEGER PRIMARY KEY,
                        key TEXT NOT NULL,
                        value TEXT NOT NULL
                        );''')
      return connection
  
  def deleteAllUsersOnLocale(self): 
    self.cursor.execute("DELETE from USERS;",)
    self.connection.commit()
  
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
      print('An exception occurred on localDb/saveNewUser(): {}'.format(error))

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
    try:
      self.cursor.execute("UPDATE USERS SET is_logined= true, x_access_key= ?, x_refresh_key= ?, websocket_access_key= ?, websocket_refresh_key= ? WHERE id=?",(user.x_access_key, user.x_refresh_key,user.websocket_access_key, user.websocket_refresh_key,  user.local_id))
      self.connection.commit()
    except Exception as error:
      print('An exception on localDbService/setUserLoginedInfo(): {}'.format(str(error)))
  def allUsersLogout(self):
    self.cursor.execute("UPDATE USERS SET is_logined = false WHERE is_logined= true")
    self.connection.commit()

  def customUserLogout(self, user: UserModel):
    self.cursor.execute("UPDATE USERS SET is_logined = false WHERE id= ?",(user.local_id,))
    self.connection.commit()
    
  def closeConnection(self):
    self.connection.close()
    
  def searchInTookNotices(self, url):
    result = self.cursor.execute("SELECT * FROM NOTICES WHERE url=?",(url,)).fetchall()
    return len(result) == 0

  def saveInTookNotices(self,url):
    self.cursor.execute("INSERT INTO NOTICES(url) VALUES(?);",(url,))
    self.connection.commit()

  def deleteAllTookNotices(self):
    self.cursor.execute("DELETE from NOTICES;",)
    self.connection.commit()
    
  def searchInNoticeLinks(self, url):
    result = self.cursor.execute("SELECT * FROM NOTICE_LINKS WHERE url=?",(url,)).fetchall()
    return len(result) == 0

  def saveInNoticeLinks(self,urlAndTopCategory):
    self.cursor.execute("INSERT INTO NOTICE_LINKS(top_category, url) VALUES(?, ?);",urlAndTopCategory)
    self.connection.commit()

  def deleteAllNoticeLinks(self):
    self.cursor.execute("DELETE from NOTICE_LINKS;",)
    self.connection.commit()

  def deleteSingleNoticeLink(self, noticeModel: LocalNotice):
    self.cursor.execute("DELETE FROM NOTICE_LINKS WHERE id = ?",(noticeModel.local_id,))
    self.connection.commit()

  def getRandomNoticeLink(self, count=1):
    findResult = self.cursor.execute("select * from NOTICE_LINKS").fetchall()
    countOfNoticeLinks = len(findResult)
    resultList = []
    for i in range(count):
      randomIndex = random.randint(0, countOfNoticeLinks-1)
      selectedLocalNoticeInfo = findResult[randomIndex]
      result = LocalNotice(selectedLocalNoticeInfo[0], selectedLocalNoticeInfo[1], selectedLocalNoticeInfo[2])
      resultList.append(result)
    return resultList
  
  def multipleRandomLogin(self,count):
    indexes = []
    users = []
    allRows = self.cursor.execute("SELECT * from USERS;").fetchall()
    if(count <= len(allRows)):
      for i in range(count):
        while True:
          randomIndex = random.randint(0, len(allRows)-1)
          if(indexes.count(randomIndex)== 0):
            indexes.append(randomIndex)
            break
      
      for i in indexes:
        currentRow= allRows[i]
        currentUser = UserModel(currentRow[2], currentRow[3], currentRow[4],  currentRow[5],  currentRow[6],  currentRow[7],  currentRow[8])
        currentUser.addLocalId(currentRow[0])
        users.append(currentUser)

      return users
    else:
      raise Exception("count is bigger than length of users list")

  def getLocalUserWithUsername(self, username):
    result = self.cursor.execute("SELECT * FROM USERS WHERE username = ?",(username,)).fetchall()[0]
    user = UserModel(result[2], result[3], result[4], result[5], result[6], result[7], result[8])
    user.addLocalId(result[0])
    user.x_refresh_key = user.x_refresh_key[0]
    return user

  def getValueFromConfigWithKey(self, key):
    try:
      result = self.cursor.execute("SELECT * FROM CONFIG WHERE key = ?",(key,)).fetchall()
      if(len(result) == 0): 
        return None
      else:
        return result[0][2]
    except Exception as error:
      print('An exception on localDbService/getValueFromConfigWithKey(): {}'.format(str(error)))
      
  def setValueFromConfigWithKey(self, key, value):
    try:
      self.cursor.execute("UPDATE CONFIG SET value = ? WHERE key= ?",(value,key))
      self.connection.commit()
    except Exception as error:
      print('An exception on localDbService/setValueFromConfigWithKey(): {}'.format(str(error)))
  
  def addValueFromConfigWithKey(self, key, value):
    searchResult = self.getValueFromConfigWithKey(key)
    if(searchResult is None):
      try:
        self.cursor.execute("INSERT INTO CONFIG(key,value) VALUES(?,?);",(key, value))
        self.connection.commit()
      except Exception as error:
          print('An exception on localDbService/addValueFromConfigWithKey(): {}'.format(str(error)))

  def deleteAllValuesFromConfig(self):
    self.cursor.execute("DELETE FROM CONFIG;")
    self.connection.commit()

localDbInstance = localDbService()