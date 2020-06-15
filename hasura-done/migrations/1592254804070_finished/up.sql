CREATE TABLE public.playlist (
    uri text NOT NULL,
    title text NOT NULL,
    description text,
    id integer NOT NULL,
    user_id text,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);
CREATE SEQUENCE public.playlists_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.playlists_id_seq OWNED BY public.playlist.id;
CREATE TABLE public.upvote (
    id integer NOT NULL,
    user_id text NOT NULL,
    playlist_id integer NOT NULL,
    upvoted_at timestamp without time zone
);
CREATE SEQUENCE public.upvotes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.upvotes_id_seq OWNED BY public.upvote.id;
CREATE TABLE public."user" (
    id text NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    created_at date DEFAULT now() NOT NULL,
    last_seen date DEFAULT now()
);
ALTER TABLE ONLY public.playlist ALTER COLUMN id SET DEFAULT nextval('public.playlists_id_seq'::regclass);
ALTER TABLE ONLY public.upvote ALTER COLUMN id SET DEFAULT nextval('public.upvotes_id_seq'::regclass);
ALTER TABLE ONLY public.playlist
    ADD CONSTRAINT playlist_uri_key UNIQUE (uri);
ALTER TABLE ONLY public.playlist
    ADD CONSTRAINT playlists_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.upvote
    ADD CONSTRAINT upvote_user_id_playlist_id_key UNIQUE (user_id, playlist_id);
ALTER TABLE ONLY public.upvote
    ADD CONSTRAINT upvotes_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.playlist
    ADD CONSTRAINT playlist_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.upvote
    ADD CONSTRAINT upvotes_playlist_id_fkey FOREIGN KEY (playlist_id) REFERENCES public.playlist(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.upvote
    ADD CONSTRAINT upvotes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
