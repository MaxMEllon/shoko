# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  account            :string           default(""), not null
#  encrypted_password :string           default(""), not null
#  name               :string           default(""), not null
#  created_at         :datetime
#  updated_at         :datetime
#  admin_flag         :boolean          default(FALSE), not null
#  grade              :integer          default(1), not null
#

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :validatable
  validates_uniqueness_of :account
  validates_presence_of :account, :name

  has_many :user_documents, dependent: :destroy
  has_many :documents, through: :user_documents

  scope :id_is, ->( id ) { find_by( id: id.to_i ) }

  include Grade

  def update_without_current_password(params, *options)
    params.delete(:current_password)
    params.delete(:password) if params[:password].blank?
    params.delete(:password_confirmation) if params[:password_confirmation].blank?

    clean_up_passwords
    update_attributes(params, *options)
  end

  def is_admin?
    admin_flag
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
