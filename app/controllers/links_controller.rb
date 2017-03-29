class LinksController < ApplicationController
  before_action :set_link, only: [:show]
  respond_to :json

  def create
    @link = Link.find_or_initialize_by(link_params)

    if @link.save
      redirect_to @link
    else
      render nothing: true, status: 402
    end
  end

  def index
    search_content_service = SearchContentService.new(params[:key_word])

    render json: search_content_service.search
  end

  def show
    web_content_service = WebContentService.new(@link)

    render text: web_content_service.content
  end

  private

  def set_link
    @link = Link.find(params[:id])
  end

  def link_params
    params.permit(:url)
  end
end
