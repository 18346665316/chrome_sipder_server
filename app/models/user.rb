class User < ApplicationRecord
    validates :name, presence: true, length: { maximum: 25 }, uniqueness:  true
    validates :password, presence: true, length: { maximum: 16, minimum: 8 }, uniqueness: {case_sensitive: false}
    validates :admin, presence: true

    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ?
                   BCrypt::Engine::MIN_COST :
                   BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

end



