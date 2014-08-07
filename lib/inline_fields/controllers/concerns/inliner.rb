module Inliner
  extend ActiveSupport::Concern

  included do
    before_action :set_inline_parent, only: [:index, :new, :create, :form_for, :form_for_update]
    before_action :set_object_from_params, only: [:form_for, :form_for_update]
  end

  module ClassMethods
    attr_accessor :inline_child
    attr_accessor :inline_parent

    def inline_object(child, parent)
      self.inline_child = child.to_s
      self.inline_parent = parent.to_s
    end

    def child_var
      "@#{self.inline_child}"
    end
    def parent_var
      "@#{self.inline_parent}"
    end
  end

  def form_for
    respond_to do |format|
      format.html { render partial: 'inline_fields/form_for', layout: false, locals: { parent: self.class.inline_parent, child: self.class.inline_child } }
      format.json { render json: instance_variable_get(child_var), status: 200 }
    end
  end

  def form_for_update
    respond_to do |format|
      format.html { render partial: 'inline_fields/form_for_update', layout: false, locals: { parent: self.class.inline_parent, child: self.class.inline_child } }
      format.json { render json: instance_variable_get(child_var), status: 200 }
    end
  end

  def set_inline_parent
    parent_id = params["#{self.class.inline_parent}_id".to_sym]
    parent_id ||= eval("#{self.class.inline_child}_params[:#{self.class.inline_parent}_id]")
    instance_variable_set("@#{self.class.inline_parent}", self.class.inline_parent.camelize.constantize.find(parent_id)) if parent_id
  end

  def set_object_from_params
    send("set_#{self.class.inline_child}")

    var = "@#{self.class.inline_child}"
    instance_variable_set var, self.class.inline_child.camelize.constantize.new unless instance_variable_defined?(var)
    instance_variable_get(var).assign_attributes(send("#{self.class.inline_child}_params"))
  end
end