# == Schema Information
#
# Table name: snippets
#
#  id         :integer          not null, primary key
#  title      :string
#  work       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  kind_id    :integer
#  user_id    :integer
#

class SnippetsController < ApplicationController
  before_action :authenticate_user, except: [:index, :show]
  before_action :find_snippet, only: [:show, :edit, :update]
  before_action :authorize_user, only: [:edit, :destroy, :update]
  
  def new
    @snippet = Snippet.new
  end

  def create
    @snippet      = Snippet.new(snippet_params)
    @snippet.user = current_user

    if @snippet.save
      # sends a empty HTTP 200
      # render nothing: true
      redirect_to @snippet, notice: "New snippet created!"
    else
      flash[:alert] = "Error, please check below"
      render :new
    end
  end

  def show
    unless can? :read, @snippet 
      redirect_to root_path, alert: "access denied!"
    end
    
  end

  def index
    # refactor, ? can be nil
    @snippets = Snippet.filtered_result(uid)
    # if user_signed_in?
    #   @snippets = Snippet.where("is_private = false OR (is_private = true AND user_id = ?)", current_user.id)
    # else
    #   @snippets = Snippet.where("is_private = false")
    # end
  end

  def edit
    
  end

  def update
    if @snippet.update snippet_params
      redirect_to @snippet, notice: "Snippet updated!"
    else
      flash[:alert] = "Error, please check below"
      render :edit
    end
  end

  private 

  def snippet_params
    params.require(:snippet).permit(:title, :work, :kind_id, :is_private)
  end

  def find_snippet
    @snippet = Snippet.find params[:id]
    # Rescue the specific error to supress it to make a test fail.
    # rescue ActiveRecord::RecordNotFound => e

  end

  def authorize_user
    #if @question.user != current_user
    unless can? :manage, @snippet 
      redirect_to root_path, alert: "access denied!"
    end
  end
end
