class JobAdsController < ApplicationController
  def index
    first_ad = JobAd.new(id: 1, title: "Senior Rails Developer", description: "Uma vaga pra mais experientes")
    second_ad = JobAd.new(id: 2, title: "Junior Rails Developer", description: "Uma vaga pra Juninhos")
    @job_ads = [ first_ad, second_ad ]
  end
end
