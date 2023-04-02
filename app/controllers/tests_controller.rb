class TestsController < Simpler::Controller

  def index
    @time = Time.now
  end

  def create

  end

  def show
    render inline: '<%= Test.find(params[:id].to_i) %>'
  end

end
