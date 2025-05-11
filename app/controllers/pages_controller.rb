class PagesController < ApplicationController
  before_action :set_page, only: [ :show ]

  def index
    @pages = Page.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @links = @page.links.page(params[:page]).per(20)
  end

  def create
    @page = Page.new(page_params)
    @page.status = "pending"

    if @page.save!
      ScrapePageJob.perform_later(@page.id)
      redirect_to pages_path, notice: "Page scraping has started."
    else
      Rails.logger.info "--> #{@page.errors}"
      render :index
    end
  end

  private

  def set_page
    @page = Page.find(params[:id])
  end

  def page_params
    params.require(:page).permit(:url)
  end
end
