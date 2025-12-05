class TeamForm
  include ActiveModel::Model

  attr_accessor :id, :name, :max_member


  validates :name, presence: { message: "Name cannot be blank" }
  validate :name_must_be_unique
  validates :max_member, presence: { message: "Max member cannot be blank" },
    numericality: { 
      only_integer: true,
      greater_than: 0,
      message: "Max member must be greater than 0"
    }
  
  validate :max_member_error
 
  def name_must_be_unique
    existing_teams = id.present? ? Team.where.not(id: id) : Team.all

    if existing_teams.exists?(name: name)
      errors.add(:name, "Name already exists")
    end
  end

  def max_member_error
    if max_member.to_i < User.where(team_id: id).count
      errors.add(:max_member, "Max member is currently lower than the current number of users in the team.")
    end
  end
end
