class Club < ActiveRecord::Base
  belongs_to :user

  def self.allowed_roles
    ["wizard", "hobbit"]
  end

  def self.disallowed_roles
    ["droid", "gangster"]
  end
end
