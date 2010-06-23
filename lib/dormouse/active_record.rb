# @author Simon Menke
module Dormouse::ActiveRecord

  extend ActiveSupport::Concern

  def manifest
    self.class.manifest
  end

end

module Dormouse::ActiveRecord::ClassMethods

  def dormouse_search(manifest, query)
    if query.size > 2
      query = "%#{query}%"
    else
      query = "#{query}%"
    end
    where("#{manifest[:_primary].names.column} LIKE ?", query)
  end

  def dormouse_paginate(manifest, page)
    limit(25).offset((page.to_i - 1) * 25)
  end

  def dormouse_order(manifest, columns)
    columns = columns.split(' ').collect do |column|
      next(nil) if column.blank?
      if column[0,1] == '-'
        "#{column[1..-1]} DESC"
      else
        "#{column} ASC"
      end
    end.compact.join(', ')
    order(columns)
  end

  def dormouse_filter(manifest, filter)
    instance_eval(manifest, &filter)
  end

  def manifest(&block)
    @manifest ||= Dormouse::Manifest.new(self)
    if block
      Dormouse::DSL.new(@manifest).instance_eval(&block)
      @manifest.reset!
    end
    @manifest
  end

  def const_missing(name)
    if name == 'ResourcesController'
      Dormouse::ActionController::Builder.build_controller(manifest)
    else
      super
    end
  end

end

class ActiveRecord::Base
  include Dormouse::ActiveRecord
end
