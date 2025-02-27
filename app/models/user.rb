# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  avatar          :string
#  comments_count  :integer
#  email           :string
#  likes_count     :integer
#  password_digest :string
#  photos_count    :integer
#  private         :boolean
#  username        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  validates :email, :uniqueness => { :case_sensitive => false }
  validates :email, :presence => true
  has_secure_password
end

