class Color < ActiveRecord::Base
  belongs_to :product
  attr_accessible :color

  before_validation :strip
  before_validation :parse_csv_and_build_additional_objects

  private
  def strip
    attribute = self.class.to_s.downcase
    self[attribute] = self.send(attribute).strip
  end

  def parse_csv_and_build_additional_objects
    attribute = self.class.to_s.downcase
    return unless self.send(attribute) =~ /,+/
    product = self.product
    build_or_create = product.persisted? ? 'create' : 'build'
    values = self.send(attribute).split(',')
    self[attribute] = values.shift
    values.each do |value|
      (product.send(attribute.pluralize)).send(build_or_create,
                                               :"#{attribute}" => value )
    end
  end
end
