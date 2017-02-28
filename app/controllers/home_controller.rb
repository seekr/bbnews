class HomeController < ApplicationController
  def index
    @query = search_params[:q] || ''

    case @query.split.first
    when 'hackernews', 'hn'
      @source = HackernewsSource.new
    end
    @results = @source.search(@query) if @source
  end

  private

  def search_params
    params.permit(:q)
  end
end