from actions.abstract_action_class import Action
from model.user_model import UserModel
import services.request_service as request_service
import random

class OfferActions(Action):
  def __init__(self):
    pass
  
  def giveOffer(self, notice_id):
    try:
      noticeDetails = request_service.getNoticeDetails(notice_id)
      if(noticeDetails["price_details"]["selling_with_offer"] == True):
        salingPrice = noticeDetails["price_details"]["saling_price"]
        salingPrice = int(salingPrice)
        offer_price = random.randint(int(salingPrice * 7/10),salingPrice-1)
        response = request_service.giveOfferRequest(self.getSingleUser(), offer_price, notice_id)
    except Exception as error:
      print('An exception occurred offer_actions/giveOffer(): {}'.format(str(error)))
  
  def acceptOffer(self,notice_id,offer_id):
    request_service.acceptOfferRequest(self.getSingleUser(), notice_id, offer_id)
  def declineOffer(self,notice_id,offer_id):
    request_service.declineOfferRequest(self.getSingleUser(), notice_id, offer_id)

  def getSalingOffers(self):
    offersResponse = request_service.getUserSalingOffersRequest(self.getSingleUser())
    return offersResponse

  def getBuyingOffers(self):
    offersResponse = request_service.getUserBuyingOffersRequest(self.getSingleUser())
    return offersResponse["buying_offers"]