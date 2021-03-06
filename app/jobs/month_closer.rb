class MonthCloser
  include Sidekiq::Worker

  def perform
    if Date.current.day == 1
      after_end_date = Time.new(Time.now.year, Time.now.month, 1, 0, 0)
      start_date = after_end_date - 1.month
      AdminNotifier.report(start_date.month, start_date.year).deliver
      Reward.where(created_at: start_date...after_end_date).update_all(is_archived: true)
    end
  end
end
