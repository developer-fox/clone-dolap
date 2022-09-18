

class UserModel:
  def __init__(self,username: str,email: str,password: str, x_access_key: str,x_refresh_key: str,websocket_access_key: str,websocket_refresh_key: str):
    self.username = username
    self.email = email
    self.password = password
    self.x_access_key = x_access_key
    self.x_refresh_key = x_refresh_key,
    self.websocket_access_key = websocket_access_key
    self.websocket_refresh_key = websocket_refresh_key


  def addLocalImagePath(self,path): 
    self.imagePath = path

  def addLocalId(self,id):
    self.local_id = id
    
  def setxAccesKey(self,x_access_key):
    self.x_access_key= x_access_key