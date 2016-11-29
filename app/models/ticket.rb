class Ticket < ApplicationRecord
  enum status: [:pending, :in_progress, :closed]

  belongs_to :customer
  belongs_to :agent, optional: true

  delegate :name, to: :customer, prefix: true
  delegate :name, to: :agent, prefix: true, allow_nil: true

  validates :description, :customer, presence: true
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :agent, presence: true, if: -> { in_progress? || closed? }

  scope :by_customer, lambda { |customer|
    return all unless customer.present?
    where(customer: customer)
  }

  scope :by_agent, lambda { |agent|
    return all unless agent.present?
    where(agent: agent)
  }

  scope :by_status, lambda { |status|
    return all unless status.present?
    where(status: status)
  }

  scope :by_updated_at, lambda { |dates|
    return all unless dates[:from].present? && dates[:to].present?
    where(updated_at: dates[:from].to_date..dates[:to].to_date)
  }

  def assign!(agent)
    if self.agent.present? && self.agent != agent
      errors.add(:agent, :forbidden, message: 'already assigned!')
      false
    else
      self.agent = agent
      in_progress!
      save
    end
  end
end
