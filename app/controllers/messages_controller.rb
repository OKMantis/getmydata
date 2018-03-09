class MessagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  # before_action :generate_token, only: [:create]

  def index
   @user = current_user
   @user_selections = current_user.user_selections.all
   @Messages = Message.all
   policy_scope(Message)
  end

  def send_messages
   @user = current_user
   authorize @user
   @message = Message.new
   @user_selections = current_user.user_selections.all
   @Messages = Message.all
   policy_scope(Message)
  end

  def show
  end

  def new
    @message = Message.new
    @company = Company.find(params[:company_id])
    authorize @message
  end

  def create
    @message = Message.new(message_params)
    @message.created_at = Time.now
    @company = Company.find(params[:company_id])
    @message.user = current_user
    @message.company = @company
    authorize @message
    if @message.save
      redirect_to profile_path
    else
      render :new
    end
  end

  def edit
    @company = Company.find(params[:company_id])
    @message.company = @company
  end

  def update
    @company = Company.find(params[:company_id])
    @message.company = Company.find(params[:company_id])
    @message.update(message_params)
    redirect_to user_messages_path(:user_id)
  end

  def destroy
    # only authorization for admin
    @message.destroy
    redirect_to user_messages_path(:user_id), :alert => "Message deleted"
  end

  protected

  def set_message
    @message = Message.find(params[:id])
    authorize @message
  end

  def message_params
    params.require(:message).permit(:date, :sent_by_user, :subject, :text, :attachment, :user_id, :company_id, :start_date, :end_date)
  end

  # def generate_token
  #   self.request_id = loop do
  #     random_token = SecureRandom.urlsafe_base64(nil, false)
  #     break random_token unless ModelName.exists?(token: random_token)
  #   end
  # end

end

