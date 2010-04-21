module Dormouse::ActiveRecord
  
  def self.included(base)
    base.extend Meta
    if Rails.respond_to?(:application)
      base.setup_dormouse_rails_30
    else
      base.setup_dormouse_rails_23
    end
  end
  
  def manifest
    self.class.manifest
  end
  
end

module Dormouse::ActiveRecord::Meta
  
  def setup_dormouse_rails_23
    named_scope :dormouse_search, lambda { |manifest, query|
      if query.size > 2
        query = "%#{query}%"
      else
        query = "#{query}%"
      end
      { :conditions =>  ["#{manifest.table_name}.#{manifest.primary_name_column} LIKE ?", query] }
    }
    
    named_scope :dormouse_paginate, lambda { |manifest, page|
      { :offset => ((page.to_i - 1) * 25), :limit => 25 }
    }
    
    named_scope :dormouse_order, lambda { |manifest, order|
      if order[0,1] == '-'
        order = "#{order[1..-1]} DESC"
      else
        order = "#{order} ASC"
      end
      { :order => order }
    }
    
    named_scope :dormouse_filter, lambda { |manifest, filter|
      filter.call(manifest)
    }
  end
  
  def setup_dormouse_rails_30
    scope :dormouse_search, lambda { |manifest, query|
      if query.size > 2
        query = "%#{query}%"
      else
        query = "#{query}%"
      end
      where("#{manifest.table_name}.#{manifest.primary_name_column} LIKE ?", query)
    }
    
    scope :dormouse_paginate, lambda { |manifest, page|
      offset((page.to_i - 1) * 25).limit(25)
    }
    
    scope :dormouse_order, lambda { |manifest, order|
      if order[0,1] == '-'
        order = "#{order[1..-1]} DESC"
      else
        order = "#{order} ASC"
      end
      order(order)
    }
    
    scope :dormouse_filter, lambda { |manifest, filter|
      instance_eval(manifest, &filter)
    }
  end
  
  def manifest(&block)
    @manifest ||= Dormouse::Manifest.new(self)
    Dormouse::DSL.new(@manifest).instance_eval(&block) if block
    @manifest
  end
  
  def const_missing(name)
    if name == 'ResourcesController'
      Dormouse::ActionController.build_controller(manifest)
    else
      super
    end
  end
  
end

class ActiveRecord::Base
  include Dormouse::ActiveRecord
end