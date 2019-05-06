class PostsController < ApplicationController

  before_action :authenticate_user
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}

  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def show
    @post = Post.find_by(id: params[:id])
    @user = @post.user
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(
      content: params[:content],
      user_id: @current_user.id,
      pic_name: "default_post.jpg"
    )

    if params[:image]
      @post.pic_name = "#{@post.id}.jpg"
      image = params[:image]
      File.binwrite("public/user_images/#{@post.pic_name}", image.read)
    end

    if @post.save
      flash[:notice] = "Content posted!!"
      redirect_to("/posts/index")
    else
      render("posts/new")
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
  end

  def update
    @post = Post.find_by(id: params[:id])
    @post.content = params[:content]

    if params[:image]
      @post.pic_name = "#{@post.id}.jpg"
      image = params[:image]
      File.binwrite("public/user_images/#{@post.pic_name}",image.read)
    end

    if @post.save
      flash[:notice] = "Content edited"
      redirect_to("/posts/index")
    else
      render("posts/edit")
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    flash[:notice] = "Content deleted"
    redirect_to("/posts/index")
  end

  def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if @post.user_id != @current_user.id
      flash[:notice] = "You can't access"
      redirect_to("/posts/index")
    end
  end

end
