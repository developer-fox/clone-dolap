
import socketio
from model.user_model import UserModel
import os
apiUrl = os.getenv("api_url")


class Socket:
  def __init__(self, user: UserModel):
    self.socketInstance = socketio.Client()
    
    auth = {
    "jwt": user.websocket_access_key,
    "jwt_refresh": user.websocket_refresh_key
    }

    @self.socketInstance.event
    def connect():
      print("connection established")
    
    @self.socketInstance.event
    def connect_error():
      print("connection failed")

    @self.socketInstance.on("activation_info")
    def activationInfo(data):
      print(data)
      
    @self.socketInstance.on("notification")
    def notification(data):
      print(data)
      
    self.socketInstance.connect(apiUrl, auth=auth)
  
  def activateUser(self):
    self.socketInstance.emit("activate_user")
    
  def deactivateUser(self):
    self.socketInstance.emit("deactivate_user")
  
  def listenUserActivation(self,user_id):
    self.socketInstance.emit("listen_user_activate",user_id)