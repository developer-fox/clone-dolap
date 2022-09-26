import services.request_service as request_service
from services.local_db_service import localDbInstance
from services.socket_service import Socket
from model.user_model import UserModel
import services.file_service as file_service
from actions.abstract_action_class import Action
import random


class NoticeActions(Action):
  def __init__(self):
    pass

  def addToFavorites(self,noticeId):
    request_service.addToFavoritesRequest(self.getSingleUser(), noticeId)
    
  def addToCart(self, noticeId):
    request_service.addToCartRequest(self.getSingleUser(), notice_id= noticeId)
    
  def addToLookedNotices(self, noticeId):
    request_service.addToLookedNoticesRequest(self.getSingleUser(), notice_id= noticeId)