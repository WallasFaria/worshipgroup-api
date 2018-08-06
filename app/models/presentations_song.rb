class PresentationsSong < ApplicationRecord
  belongs_to :song
  belongs_to :presentation

  def name
    self.song.name
  end

  def artist
    self.song.artist
  end

  def url_youtube
    self.song.url_youtube
  end

  def url_cipher
    self.song.url_cipher
  end
end
