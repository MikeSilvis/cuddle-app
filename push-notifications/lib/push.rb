require 'rubygems'
require 'bundler'
Bundler.require

class Push
  Parse.init :application_id => "7qRCV3hz4fajvJovE942RlmEyIbkp6f82NUwrQCW",
             :api_key        => "HZza9DiUFY46POu1cfNB9uD06KSKzPVsPMFncRHa"

  def self.send_notification
    drifting_connections.each do |connection|
      puts "Connection is: #{connection[:contact]}"
      pf_push = Parse::Push.new(push_data(connection[:contact]), connection[:userObjectId])
      pf_push.type = 'ios'
      pf_push.save
      update_push_notified_flag(connection[:contact]["objectId"])
    end
  end

  def self.update_push_notified_flag(objectId)
    colleague = Parse.get "Colleague", objectId
    colleague.delete("photo")
    colleague["notifiedSincePush"] = false
    colleague.save
  end

  def self.push_data(contact)
    {
      :alert => "You haven't contacted #{contact['name']} since #{contact['updatedAtFormated']}."
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
      q.less_eq("updatedAt", two_weeks_ago )
      q.eq("notifiedSincePush", true)
      q.order_by = "updatedAt"
      q.include = 'user'
    end.get
  end

  def self.two_weeks_ago
    Parse::Date.new((Time.now - (60*60*24*14)).to_datetime)
  end

end