
import services.request_service as request_service
from services.local_db_service import localDbInstance
from services.socket_service import Socket
from model.user_model import UserModel
import services.file_service as file_service
from actions.abstract_action_class import Action
import random

class SaleActions(Action):
  def __init__(self):
    pass
  
  def getCart(self):
    response = request_service.getCartRequest(self.getSingleUser())
    return response.json()["json"]["cart"]

  def checkCart(self,address_id):
    response = request_service.checkCartRequest(self.getSingleUser(), address_id)
  
  def cancelBuying(self,soldNoticeId):
    response = request_service.cancelBuyingRequest(self.getSingleUser(), soldNoticeId)
    
  
  