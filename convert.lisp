(defstruct entry
  game cover engine setup runtime store hints genre tags year dev pub version status added updated idgb-id)

(defmacro with-fields ((&rest fields) &body body)
  `(destructuring-bind ,fields
       (loop for field in ',fields
	     collect field)
     ,@body))

(defun entry-to-json (entry)
  `(json:make-object
    :game-name ,(string (entry-game entry))
    :cover ,(entry-cover entry)
    :engine ,(entry-engine entry)
    :setup ,(entry-setup entry)
    :runtime ,(entry-runtime entry)
    :store ,(entry-store entry)
    :hints ,(entry-hints entry)
    :genre ,(entry-genre entry)
    :tags ,(entry-tags entry)
    :year ,(entry-year entry)
    :dev ,(entry-dev entry)
    :pub ,(entry-pub entry)
    :version ,(entry-version entry)
    :status ,(entry-status entry)
    :added ,(entry-added entry)
    :updated ,(entry-updated entry)
    :igdb-id ,(entry-igdb-id entry)))

(defmacro read-entry (stream)
  `(progn
     (ignore-errors
      (with-fields (game cover engine setup runtime store hints genre tags year dev pub version status added updated igdb-id)
	(list
	 :game (read-line ,stream)
	 :cover (read-line ,stream)
	 :engine (read-line ,stream)
	 :setup (read-line ,stream)
	 :runtime (read-line ,stream)
	 :store (read-line ,stream)
	 :hints (read-line ,stream)
	 :genre (read-line ,stream)
	 :tags (read-line ,stream)
	 :year (parse-integer (read-line ,stream))
	 :dev (read-line ,stream)
	 :pub (read-line ,stream)
	 :version (read-line ,stream)
	 :status (parse-integer (read-line ,stream))
	 :added (read-line ,stream)
	 :updated (read-line ,stream)
	 :igdb-id (parse-integer (read-line ,stream)))))))
  
(defun read-entries (file)
  (with-open-file (stream file :direction :input)
    (loop for entry = (read-entry stream)
	  while entry collect entry)))

(defun write-json-to-file (data file)
  (with-open-file (stream file :direction :output :if-exists :supersede)
    (format stream "~a" (json:encode-json data))))

(let ((entries (read-entries "openbsd-games.db")))
  (write-json-to-file (mapcar #'entry-to-json entries) "openbsd-games.json"))
