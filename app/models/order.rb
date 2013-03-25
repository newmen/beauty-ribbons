# Abstract type
class Order < ActiveRecord::Base
  attr_accessible :username, :email, :comment, :note, :product_ids
  has_and_belongs_to_many :products

  default_scope order('id DESC')

  after_create :do_checkout

  state_machine initial: :confirmed do
    after_transition confirmed: :processing, do: :do_process
    after_transition processing: :completed, do: :do_complete
    after_transition all => :canceled, do: :do_cancel

    event :switch_to_next_state do
      transition confirmed: :processing, processing: :completed
    end

    event :cancel do
      transition all => :canceled
    end
  end

  def next_state
    states = %w(confirmed processing completed)
    curr_state_index = states.index(state)
    states[curr_state_index + 1] if curr_state_index
  end

  def email_with_name
    "#{username} <#{email}>"
  end
end
