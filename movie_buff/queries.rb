# == Schema Information
#
# Table name: actors
#
#  id          :integer      not null, primary key
#  name        :string
#
# Table name: movies
#
#  id          :integer      not null, primary key
#  title       :string
#  yr          :integer
#  score       :float
#  votes       :integer
#  director_id :integer
#
# Table name: castings
#  id          :integer      not null, primary key
#  movie_id    :integer      not null
#  actor_id    :integer      not null
#  ord         :integer


def movie_names_before_1940
  # Find all the movies made before 1940. Show the id, title, and year.
  Movie.where(:yr => 0...1940)
    .select(:id, :title, :yr)
end

def eighties_b_movies
	# List all the movies from 1980-1989 with scores falling between 3 and 5 (inclusive). Show the id, title, year, and score.
  Movie.where(:yr => 1980..1989)
    .where(:score => 3..5)
    .select(:id, :title, :yr, :score)
end

def vanity_projects
  # List the title of all movies in which the director also appeared as the starring actor. Show the movie id and title and director's name.

  # Note: Directors appear in the 'actors' table.
  Movie.joins(:actors)
    .where("movies.director_id = actors.id")
    .where("castings.ord = 1")
    .select("movies.id, movies.title, actors.name")
end

def starring(whazzername)
	# Find the movies with an actor who had a name like `whazzername`.
	# A name is like whazzername if the actor's name contains all of the letters in whazzername, ignoring case, in order.

	# ex. "Sylvester Stallone" is like "sylvester" and "lester stone" but not like "stallone sylvester" or "zylvester ztallone"
  whazzername = whazzername.downcase.chars.join('%')
  Movie.joins(:actors)
    .where("actors.name ILIKE ?", "%#{whazzername}%")
    .load
end

def bad_years
  # List the years in which a movie with a rating above 8 was not released.
  Movie.select(:yr)
    .group(:yr)
    .having("MAX(movies.score) < 8")
    .to_a.map(&:yr)
end

def golden_age
	# Find the decade with the highest average movie score.
  Movie.select("10 * (movies.yr / 10) AS decade")
    .group("movies.yr / 10")
    .order("AVG(movies.score) DESC")
    .limit(1)
    .first.decade
end

def cast_list(title)
  # List all the actors for a particular movie, given the title.  Sort the results by starring order (ord).
  Actor.joins(:movies)
    .where("movies.title = ?", title)
    .order("castings.ord")
    .load
end

def costars(name)
  # List the names of the actors that the named actor has ever appeared with.
  actors = Actor.joins(:movies => :actors)
    .where("actors.name = ?", name)
    .select("actors_movies.name")
    .uniq.map(&:name)
  actors.delete(name)
  actors
end

def most_supportive
  # Find the two actors with the largest number of non-starring roles. Show each actor's id, name and number of supporting roles.
  Actors.joins(:castings)
    .limit(2)
end

def what_was_that_one_with(those_actors)
	# Find the movies starring all `those_actors` (an array of actor names). Show each movie's title and id.

end

def actor_out_of_work
  # Find the number of actors in the database who have not appeared in a movie

end

def longest_career
	#Find the actor and list all the movies of the actor who had the longest career (the greatest time between first and last movie).

end
