require 'rubygems'
require 'byebug'
require 'bundler'
Bundler.require

class Push
  DEV_APPLICATION_ID =  "7TZmoyE9Rdg5KvRTrEX8KctSDJ7NplhH1Oz7DR9H"
  DEV_API_KEY = "EWx7bYVDHGaUf4SOrEWRcNZ3TJTSDKyxz12NeIL5"
  PROD_APPLICATION_ID = "7qRCV3hz4fajvJovE942RlmEyIbkp6f82NUwrQCW"
  PROD_API_KEY = "HZza9DiUFY46POu1cfNB9uD06KSKzPVsPMFncRHa"
  #Parse.init :application_id => DEV_APPLICATION_ID, :api_key => DEV_API_KEY
  Parse.init :application_id => PROD_APPLICATION_ID, :api_key => PROD_API_KEY

  def self.send_notification
    drifting_connections.each do |connection|
      puts "Connection is: #{connection[:contact]}"
      pf_push = Parse::Push.new(push_data(connection[:contact]), "user_#{connection[:userObjectId]}")
      pf_push.type = 'ios'
      pf_push.save
      puts "Notification sent as: #{push_data(connection[:contact])} to user_#{connection[:userObjectId]}"
      #update_push_notified_flag(connection[:contact]["objectId"])
    end
  end

  def self.update_push_notified_flag(objectId)
    colleague = Parse.get "Colleague", objectId
    ## This isn't actually deleting the photo
    ## It is simply removing it from the array
    ## Such that when I save it doesnt try to reupload it
    colleague.delete("photo")
    colleague["notifiedSincePush"] = false
    colleague.save
  end

  def self.push_data(contact)
    {
      alert: "How is #{contact['name']} doing? Panda thinks you should ask.",
      c: contact['objectId']
    }
  end

  def self.drifting_connections
    contacts_grouped_by_user.map do |user|
      {
        userObjectId: user[0]["objectId"],
        contact: {
                  "name" => user[1][0]["name"],
                  "notifiedSincePush" => user[1][0]["notifiedSincePush"],
                  "updatedAt" => user[1][0]["updatedAt"],
                  "updatedAtFormated" => DateTime.parse(user[1][0]["updatedAt"]).strftime("%B %d"),
                  "objectId" => user[1][0]["objectId"]
                 }
      }
    end
  end

  def self.contacts_grouped_by_user
    find_outdated_contacts.group_by do |contact|
      contact["user"]
    end
  end

  def self.find_outdated_contacts
    Parse::Query.new("Colleague").tap do |q|
      q.less_eq("lastContactDate", one_week_ago )
      q.eq("notifiedSincePush", true)
      q.order_by = "lastContactDate,updatedAt"
      q.include = 'user'
    end.get.select do |c|
      c["lastContactDate"].value.to_time < (Time.now - (60*60*24*c["frequency"].to_i))
    end
  end

  def self.two_weeks_ago
    Parse::Date.new((Time.now - (60*60*24*14)).to_datetime)
  end

  def self.one_week_ago
    Parse::Date.new((Time.now - (60*60*24*7)).to_datetime)
  end

  def self.one_month_ago
    Parse::Date.new((Time.now - (60*60*24*28)).to_datetime)
  end

end
