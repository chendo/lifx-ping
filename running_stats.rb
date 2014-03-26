# Adapted from: http://www.johndcook.com/standard_deviation.html
class RunningStats
  def initialize
    @count = 0
  end

  def <<(value)
    @count += 1

    if @count == 1
      @old_mean = @new_mean = value
      @old_stddev = 0
    else
      @new_mean = @old_mean + (value - @old_mean) / @count.to_f
      @new_stddev = @old_stddev + (value - @old_mean) * (value - @new_mean)

      @old_mean = @new_mean
      @old_stddev = @new_stddev
    end
  end

  def count
    @count
  end

  def mean
    count > 0 ? @new_mean : 0.0
  end

  def variance
    count > 1 ? @new_stddev / (count - 1).to_f : 0.0
  end

  def std_dev
    Math.sqrt(variance)
  end
end
