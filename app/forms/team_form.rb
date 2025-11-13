class TeamForm
  include ActiveModel::Model

  attr_accessor :id, :name, :max_member


  validates :name, presence: { message: "Name cannot be blank" }
  validate :name_must_be_unique
  validates :max_member, presence: { message: "Max number cannot be blank" },
    numericality: { 
      only_integer: true,
      greater_than: 0,
      message: "Max number must be greater than 0"
    }
 
  def name_must_be_unique
    existing_teams = id.present? ? Team.where.not(id: id) : Team.all

    if existing_teams.exists?(name: name)
      errors.add(:name, "Name already exists")
    end
  end

end
