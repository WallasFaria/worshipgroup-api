class PresentationsSong < ApplicationRecord
  belongs_to :song
  belongs_to :presentation

  VALID_TONES = [
    'A', 'Am', 'A#', 'A#m',
    'B', 'Bm',
    'C', 'Cm', 'C#', 'C#m',
    'D', 'Dm', 'D#', 'D#m',
    'E', 'Em',
    'F', 'Fm', 'F#', 'F#m',
    'G', 'Gm', 'G#', 'G#m'
  ]

  validates :tone, inclusion: { in: VALID_TONES, allow_blank: true }

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
