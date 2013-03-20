##
# Provides a clean and simple API to detect duplicate image files using
# the pHash library under the covers.
#
# The C API:
# int ph_dct_imagehash(const char *file, ulong64 &hash);
# int ph_hamming_distance(ulong64 hasha, ulong64 hashb);

module Phashion
  VERSION = '1.0.5'

  class Image
    SETTINGS = {
      :dupe_threshold => 15
    }

    attr_reader :filename
    def initialize(filename)
      @filename = filename
    end

    def duplicate?(other)
      Phashion.hamming_distance(fingerprint, other.fingerprint) < SETTINGS[:dupe_threshold]
    end

    def fingerprint(type = :phash)
      if type == :phash
        @hash ||= Phashion.image_hash_for(@filename)
      else
        @mhash ||= Phashion.image_mhash_for(@filename)
      end
    end

    def fingerprint_string(type = :phash)
      if type == :phash
        fingerprint(type).to_s(2)
      else
        fingerprint(type).map {|i| i.to_s(2)}.join('')
      end
    end
  end
end

require 'phashion_ext'
