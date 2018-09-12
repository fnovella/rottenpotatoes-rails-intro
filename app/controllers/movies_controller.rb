class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort = params[:sort] || session[:sort]
    @all_ratings = Movie.get_ratings
    @wanted_ratings = []
    if (params[:ratings])
      params[:ratings].each {|k,v| @wanted_ratings << k}
    else
      @wanted_ratings = nil
    end
    @ratings = @wanted_ratings || session[:ratings] || @all_ratings
    @movies = Movie.where(:rating => @ratings).order(@sort)
    session[:sort] = @sort
    session[:ratings] = @wanted_ratings
    
    if (params[:sort] != @sort) || (params[:ratings] != @ratings)
      flash.keep
      redirect_to movies_path sort: @sort, ratings: @ratings
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
