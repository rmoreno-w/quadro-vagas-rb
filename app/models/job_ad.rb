class JobAd
  attr_accessor :id, :title, :description
  def initialize(id:, title:, description:)
    @id = id
    @title = title
    @description = description
  end
end
