class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  
  
  #  $save_date = Date.today #<< 3
  # $this_month = nil

  $this_date = Date.today
  

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
    @count = 1
    @data_count = 0

    if params[:start_date].blank?
      $this_date = Date.today
    else
      $this_date = Date.parse(params[:start_date])
    end

  end

  def admin
    @posts = Post.all
    @count = 1
    @data_count = 0

    if params[:start_date].blank?
      $this_date = Date.today
    else
      $this_date = Date.parse(params[:start_date])
    end

  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new(start_time: params[:start_time])
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    @post.start_time = params[:start_time]
  end

  # POST /posts
  # POST /posts.json
  def create
    if Post.where(post_params).count == 0
      @post = Post.new(post_params)
      # if $save_date < @post.start_time
      #   $save_date = @post.start_time
      # end

      # linebot

    #   message = 
    #   {
    #     type: 'text',
    #     text: "浩太郎が晩ごはん情報を作成しました。\n#{@post.start_time} : #{@post.content}"
    # }
    # client = Line::Bot::Client.new { |config|
    #     config.channel_secret = "da5be14c010d092c6a188bf9fb79f071"
    #     config.channel_token = "l6MsxS40JGaFsZlSSR3br5fZ1i6Ofks3hELPEne65kqzM695FyfjS1fgVUMWB93Vt/XCa0mY9nZTdOJ7/eqYoQnFCzEEBDrV7kiILjIqqf7+1Nqj7vpxnmZO6vUgwYWhU4RzTt6hH49bykuVByprcwdB04t89/1O/w1cDnyilFU="
    # }
    # response = client.push_message("Ubb563e765d94830aa20f3a1a251de66c", message)
    # p response

    # ここまで


    else
      @post = Post.where(post_params).first
      redirect_to edit_post_path(@post,start_time: @post.start_time) and return
    end

    respond_to do |format|
      if @post.save && request.referer&.include?(posts_admin_path)
        format.html { redirect_to edit_post_path(@post,start_time: @post.start_time) }
        format.json { render :show, status: :created, location: @post }
      elsif @post.save && request.referer&.include?(new_post_path)
        format.html { redirect_to posts_admin_path(start_date: @post.start_time), notice: '晩ごはん情報が作成されました' }
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
        format.html { redirect_to posts_admin_path(start_date: @post.start_time), notice: '晩ごはん情報が更新されました' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:comment,:content, :start_time)
    end
end
