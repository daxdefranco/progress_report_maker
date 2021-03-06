class StudentGroupsController < ApplicationController
  include ApplicationHelper
  include StudentGroupsHelper
  
  before_filter :get_user
  before_filter :get_student_group, except: [:index, :new, :create]

  def index
    @student_groups = @user.student_groups
    @title = "All groups"
  end
  
  def new
    @student_group  = @user.student_groups.build
    @student = Student.new
    @title = "Create a new group"
  end

  def show
    @title = "#{@student_group.name}"
  end
  
  def create
    # @student_group = @user.student_groups.new(params[:student_group]) 
    @params = params[:student_group][:students_attributes]
    @student_group = @user.student_groups.build(params[:student_group])
    if @student_group.save
      create_students if @params.present?
      redirect_to new_student_group_subject_path(@student_group), 
                  flash: { success: "#{@student_group.name} has been added successfully." }   
    else
      ### http://railsforum.com/viewtopic.php?pid=40056#p40056  
      @student = @student_group.students.build
      @title = "Create a new group"
      view_context.flash_failure
      render 'new' 
    end  
  end
  
  def edit
    @title = "Edit group"
  end

  def update
    if @student_group.update_attributes(params[:student_group])
      redirect_to groups_path, flash: { success: "#{@student_group.name} updated successfully" }
    else  
      @title = "Edit group"
      view_context.flash_failure
      render 'edit'
    end  
  end

  def destroy
    @student_group.destroy
    redirect_to groups_path, flash: { success: "#{@student_group.name} has been deleted" }
  end 
  
  #methods
  def get_user
    @user = current_user
  end
  
  def get_student_group
    @student_group = @user.student_groups.find(params[:id])
  end
  
end