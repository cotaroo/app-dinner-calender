class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  def admin
    @posts = Post.all
  end

  # GET /posts/new
  def new
    @post = Post.new(start_time: params[:start_time], end_time: params[:start_time])
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    # @post.start_time = params[:start_time]
    # @post.end_time = params[:end_time]
  end

  # POST /posts
  # POST /posts.json
  def create
      @post = Post.new(post_params)

      if Post.where('start_time <= ? and start_time > ?', @post.end_time, @post.start_time).count > 0
        Post.where('start_time <= ? and start_time > ?', @post.end_time, @post.start_time).destroy_all
      end
     
    respond_to do |format|
      if @post.save 
        format.html { redirect_to posts_admin_path(start_date: @post.start_time), notice: '新しい予定が作成しました' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to posts_admin_path(start_date: @post.start_time), notice: '予定を編集しました' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:content, :comment, :start_time, :end_time)
    end
end
