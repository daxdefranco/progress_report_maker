# == Schema Information
#
# Table name: student_groups
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  type_of_group :string(255)
#

class StudentGroup < ActiveRecord::Base
  ### https://github.com/ryanb/nested_form/issues/222
  attr_accessor :_destroy
  attr_accessible :name, :type_of_group, :students_attributes
  
  belongs_to :user
  has_many   :students, dependent: :destroy
  has_many   :subjects, dependent: :destroy
  
  accepts_nested_attributes_for :students, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :subjects, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
  
  
  VALID_TYPES = ["Young learners class (0-6)", "Primary class (7-12)", "Secondary class (13-17)", "Adult class (18+)", "Children's sport team", "Adult's sport team"]
  
  validates :user_id,          presence: true
  validates :name,             presence: true,
                               length:   0..25
  validates :type_of_group,    inclusion: { :in => VALID_TYPES,
                                            :message => "%{value} is not a valid type" }
  
  before_save { |group| group.name = name.titleize }
    
  # methods

  def has_goals?
    subjects.any? { |subject| subject.goals.present? }
  end
  
  def eval_count
    #evals is a student method
    students.first.evals.count
  end

end
