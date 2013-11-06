
module Webex
  access_to(:mc) { frame(:name,"header").td(:id,"itemTDMC")}
  access_to(:claendar) { frame(:name,"mainFrame").frame(:name,"main").img(:alt,"Calendar")}
  access_to(:joinnow) { button(:name,"JoinNow") }
end