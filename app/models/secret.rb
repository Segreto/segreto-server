class Secret < ActiveRecord::Base
  attr_encrypted :key, key: ENV['SEGRETO_SECRET_KEY']
  validates :key, presence: true
  validate :key_must_be_unique_for_user
  attr_encrypted :value, key: ENV['SEGRETO_SECRET_KEY']
  validates :value, presence: true
  attr_encrypted :client_iv, key: ENV['SEGRETO_SECRET_KEY']
  belongs_to :user

  def key_must_be_unique_for_user
    unless user.secrets.select{ |s| (s.key == key) && (s.id != id) } == []
      errors.add :key, "must be unique per user"
    end
  end

  def as_json options={}
    json = super(options.merge(only: []))
    decrypted_fields = { key: key, value: value, client_iv: client_iv }
    if options[:root]
      json['secret'].merge! decrypted_fields
    else
      json.merge! decrypted_fields
    end
    json
  end
end
