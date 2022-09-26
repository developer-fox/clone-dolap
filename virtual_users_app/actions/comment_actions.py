
from actions.abstract_action_class import Action
from model.user_model import UserModel
import services.request_service as request_service

class CommentActions(Action):
  def __init__(self):
    pass

  def addRandomComment(self,notice_id):
    content = request_service.getRandomCommentContent()[0]
    response = request_service.addCommentToNoticesRequest(self.getSingleUser(), notice_id, content)

  def addAnswerToNotice(self,notice_id,comment_id):
    response = request_service.addAnswerToNoticeRequest(self.getSingleUser(), notice_id, comment_id)
    
  def addRating(self):
    response = request_service.getTakenNoticesRequest(self.getSingleUser())["taken_notices"]
    if(len(response)>0):
      for takenNotice in response:
        lastState = takenNotice["states"][len(takenNotice["states"])-1]["state_type"]
        if((lastState == "Teslim edildi") and (takenNotice["is_rated"] == False)):
          print(lastState)
          soldNoticeId = takenNotice["_id"]
          salerId = takenNotice["notice"]["saler_user"]
          valitidityRate = getRateScore()
          communicationRate = getRateScore()
          packingRate = getRateScore()
          ratingResult = {"packing_rate": packingRate, "validity_rate": valitidityRate,"communication_rate": communicationRate}
          ratingContent = request_service.getRandomCommentContent()[0]
          ratingResult.update({"content": ratingContent})
          ratingResult.update({"user_id": salerId, "sold_notice_id": soldNoticeId})
          request_service.addRatingRequest(self.getSingleUser(), ratingResult)