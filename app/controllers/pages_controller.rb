class PagesController < ApplicationController
  before_action :load_donate_fee, except: :not_found

  def home
    @news = News.active.ordered.limit(8)
    @junior_events = Event.active.junior.where('end_date >= ?', Date.today).ordered.limit(3)
    @irish_events = Event.active.where(category: %w(irish women)).where('end_date >= ?', Date.today).ordered.limit(4)
    @results = Result.recent
  end

  def home2
    @news = News.active.nonjunior.ordered.limit(8)
    @irish_events = Event.active.where(category: %w(irish women)).where('end_date >= ?', Date.today).ordered.limit(4)
    @results = Result.recent
  end

  def juniors
    @news = News.active.junior.ordered.limit(8)
    @junior_events = Event.active.junior.where('end_date >= ?', Date.today).ordered.limit(4)
    @international_events = Event.active.junint.where('end_date >= ?', Date.today).ordered.limit(4)
    @junior_clubs = Club.active.junior
  end

  def beginners
    @news = News.active.beginners
    @junior_clubs = Club.active.junior
    @clubs = Club.active
  end

  def not_found
    render file: "#{Rails.root}/public/404", formats: [:html], layout: false, status: 404
  end

  private

  def load_donate_fee
    @donate_fee = Fee.where(name: "Donation").first
  end
end
