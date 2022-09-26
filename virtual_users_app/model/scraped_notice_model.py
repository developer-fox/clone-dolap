
class ScrapedNoticeModel:
  def __init__(self, info_dict, photoPaths):
    self.description = info_dict['description']  
    self.top_category = info_dict['top_category']
    self.medium_category = info_dict['medium_category']
    self.bottom_category = info_dict['bottom_category']
    self.detail_category = info_dict['detail_category'] if info_dict['detail_category'] is not None else info_dict['bottom_category']
    self.brand = info_dict['brand']
    self.title = self.brand + " " + self.detail_category
    self.use_case = info_dict['use_case']
    self.color = info_dict['color'] 
    if(info_dict['top_category'] != "Elektronik"):
      self.size = info_dict['size']
    self.size_of_cargo = info_dict['size_of_cargo'] 
    self.payer_of_cargo = info_dict['payer_of_cargo']
    self.buying_price = info_dict['buying_price']
    self.saling_price = info_dict['saling_price']
    self.selling_with_offer = info_dict['selling_with_offer']
    self.photoPaths =  photoPaths
    
  def modelToRequestBodyNotation(self):
    return {
      "data": {
        "title": self.title,
        "description": self.description,
        "category": {
          "top_category": self.top_category,
          "medium_category": self.medium_category,
          "bottom_category": self.bottom_category,
          "detail_category": self.detail_category,
        },
        "brand": self.brand,
        "use_case": self.use_case,
        "color": self.color,
        "size": self.size,
        "size_of_cargo": self.size_of_cargo,
        "payer_of_cargo": self.payer_of_cargo,
        "price_details": {
          "saling_price": self.saling_price,
          "buying_price": self.buying_price,
          "selling_with_offer": self.selling_with_offer,
          "initial_price": self.saling_price,
        }
      }
    }
    
