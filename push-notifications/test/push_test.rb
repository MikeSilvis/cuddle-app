require 'test_helper'
require_relative '../lib/push.rb'

describe Push do

  #it "sends push notifications" do
    #VCR.use_cassette('push_notificaiton', record: :all) do
      #Push.stub :drifting_connections, [drifting_connections_stub] do
        #assert_equal alert_message, Push.push_data(drifting_connections_stub[:contact])
        #Push.send_notification
      #end
    #end
  #end

private

  def alert_message
    {
      alert: "You haven't contacted Trevor Taylor since March 11."
    }
  end

  def drifting_connections_stub
    {
      :userObjectId=>"bKQ4rNeSqp",
      :contact=> {
            "name"=>"Trevor Taylor",
            "notifiedSincePush"=>true,
            "updatedAt"=>"2013-03-11T05:15:02.835Z",
            "updatedAtFormated"=>"March 11",
            "objectId"=>"SP1BjXf06b"
      }
    }
  end

end
