PGDMP                      }            hakanton_db    17.4    17.4 2    ^           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            _           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            `           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            a           1262    16388    hakanton_db    DATABASE     q   CREATE DATABASE hakanton_db WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'ru-RU';
    DROP DATABASE hakanton_db;
                     postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
                     pg_database_owner    false            b           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                        pg_database_owner    false    4            �            1259    16392    account    TABLE     �   CREATE TABLE public.account (
    id integer NOT NULL,
    login text NOT NULL,
    password text NOT NULL,
    role_id integer NOT NULL,
    token text NOT NULL
);
    DROP TABLE public.account;
       public         heap r       postgres    false    4            �            1259    16391    account_id_seq    SEQUENCE     �   ALTER TABLE public.account ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.account_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    218    4            �            1259    16419    bonus    TABLE     �   CREATE TABLE public.bonus (
    id integer NOT NULL,
    id_partner integer NOT NULL,
    naim text NOT NULL,
    count numeric NOT NULL,
    id_category integer
);
    DROP TABLE public.bonus;
       public         heap r       postgres    false    4            �            1259    16418    bonus_id_seq    SEQUENCE     �   ALTER TABLE public.bonus ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.bonus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    4    224            �            1259    16467    category    TABLE     R   CREATE TABLE public.category (
    id integer NOT NULL,
    naim text NOT NULL
);
    DROP TABLE public.category;
       public         heap r       postgres    false    4            �            1259    16466    category_id_seq    SEQUENCE     �   ALTER TABLE public.category ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    228    4            �            1259    16431 
   nach_bonus    TABLE        CREATE TABLE public.nach_bonus (
    id_bonus integer,
    date_nach date,
    id_volonter integer,
    id integer NOT NULL
);
    DROP TABLE public.nach_bonus;
       public         heap r       postgres    false    4            �            1259    16564    nach_bonus_id_seq    SEQUENCE     �   ALTER TABLE public.nach_bonus ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.nach_bonus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    4    226            �            1259    16413    partner    TABLE     n   CREATE TABLE public.partner (
    id integer NOT NULL,
    naim text NOT NULL,
    id_acc integer NOT NULL
);
    DROP TABLE public.partner;
       public         heap r       postgres    false    4            �            1259    16412    partner_id_seq    SEQUENCE     �   ALTER TABLE public.partner ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.partner_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    4    222            �            1259    16400    role    TABLE     N   CREATE TABLE public.role (
    id integer NOT NULL,
    naim text NOT NULL
);
    DROP TABLE public.role;
       public         heap r       postgres    false    4            �            1259    16399    role_id_seq    SEQUENCE     �   ALTER TABLE public.role ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    220    4            �            1259    16424    volonter    TABLE     �   CREATE TABLE public.volonter (
    id integer NOT NULL,
    fio text,
    inn text,
    tel text,
    "DOB" date,
    id_acc integer NOT NULL,
    dost text
);
    DROP TABLE public.volonter;
       public         heap r       postgres    false    4            �            1259    16557    volonter_id_seq    SEQUENCE     �   ALTER TABLE public.volonter ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.volonter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    225    4            O          0    16392    account 
   TABLE DATA           F   COPY public.account (id, login, password, role_id, token) FROM stdin;
    public               postgres    false    218   �6       U          0    16419    bonus 
   TABLE DATA           I   COPY public.bonus (id, id_partner, naim, count, id_category) FROM stdin;
    public               postgres    false    224   JU       Y          0    16467    category 
   TABLE DATA           ,   COPY public.category (id, naim) FROM stdin;
    public               postgres    false    228   �U       W          0    16431 
   nach_bonus 
   TABLE DATA           J   COPY public.nach_bonus (id_bonus, date_nach, id_volonter, id) FROM stdin;
    public               postgres    false    226   �U       S          0    16413    partner 
   TABLE DATA           3   COPY public.partner (id, naim, id_acc) FROM stdin;
    public               postgres    false    222   �W       Q          0    16400    role 
   TABLE DATA           (   COPY public.role (id, naim) FROM stdin;
    public               postgres    false    220   X       V          0    16424    volonter 
   TABLE DATA           J   COPY public.volonter (id, fio, inn, tel, "DOB", id_acc, dost) FROM stdin;
    public               postgres    false    225   wX       c           0    0    account_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.account_id_seq', 329, true);
          public               postgres    false    217            d           0    0    bonus_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.bonus_id_seq', 3, true);
          public               postgres    false    223            e           0    0    category_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.category_id_seq', 3, true);
          public               postgres    false    227            f           0    0    nach_bonus_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.nach_bonus_id_seq', 300, true);
          public               postgres    false    230            g           0    0    partner_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.partner_id_seq', 6, true);
          public               postgres    false    221            h           0    0    role_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('public.role_id_seq', 3, true);
          public               postgres    false    219            i           0    0    volonter_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.volonter_id_seq', 319, true);
          public               postgres    false    229            �           2606    16398    account account_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.account DROP CONSTRAINT account_pkey;
       public                 postgres    false    218            �           2606    16453    bonus bonus_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.bonus
    ADD CONSTRAINT bonus_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.bonus DROP CONSTRAINT bonus_pkey;
       public                 postgres    false    224            �           2606    16473    category category_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.category DROP CONSTRAINT category_pkey;
       public                 postgres    false    228            �           2606    16569    nach_bonus nach_bonus_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.nach_bonus
    ADD CONSTRAINT nach_bonus_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.nach_bonus DROP CONSTRAINT nach_bonus_pkey;
       public                 postgres    false    226            �           2606    16460    partner partner_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.partner
    ADD CONSTRAINT partner_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.partner DROP CONSTRAINT partner_pkey;
       public                 postgres    false    222            �           2606    16404    role role_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.role DROP CONSTRAINT role_pkey;
       public                 postgres    false    220            �           2606    16588    account token 
   CONSTRAINT     Y   ALTER TABLE ONLY public.account
    ADD CONSTRAINT token UNIQUE (token) INCLUDE (token);
 7   ALTER TABLE ONLY public.account DROP CONSTRAINT token;
       public                 postgres    false    218            �           2606    16585    account unique_login 
   CONSTRAINT     P   ALTER TABLE ONLY public.account
    ADD CONSTRAINT unique_login UNIQUE (login);
 >   ALTER TABLE ONLY public.account DROP CONSTRAINT unique_login;
       public                 postgres    false    218            �           2606    16441    volonter volonter_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.volonter
    ADD CONSTRAINT volonter_pkey PRIMARY KEY (id) INCLUDE (id);
 @   ALTER TABLE ONLY public.volonter DROP CONSTRAINT volonter_pkey;
       public                 postgres    false    225            �           2606    16454    nach_bonus id_bonus    FK CONSTRAINT     }   ALTER TABLE ONLY public.nach_bonus
    ADD CONSTRAINT id_bonus FOREIGN KEY (id_bonus) REFERENCES public.bonus(id) NOT VALID;
 =   ALTER TABLE ONLY public.nach_bonus DROP CONSTRAINT id_bonus;
       public               postgres    false    4783    224    226            �           2606    16442    volonter idacc    FK CONSTRAINT     x   ALTER TABLE ONLY public.volonter
    ADD CONSTRAINT idacc FOREIGN KEY (id_acc) REFERENCES public.account(id) NOT VALID;
 8   ALTER TABLE ONLY public.volonter DROP CONSTRAINT idacc;
       public               postgres    false    218    225    4773            �           2606    16558    partner idacc    FK CONSTRAINT     w   ALTER TABLE ONLY public.partner
    ADD CONSTRAINT idacc FOREIGN KEY (id_acc) REFERENCES public.account(id) NOT VALID;
 7   ALTER TABLE ONLY public.partner DROP CONSTRAINT idacc;
       public               postgres    false    218    222    4773            �           2606    16474    bonus idcategory    FK CONSTRAINT     �   ALTER TABLE ONLY public.bonus
    ADD CONSTRAINT idcategory FOREIGN KEY (id_category) REFERENCES public.category(id) NOT VALID;
 :   ALTER TABLE ONLY public.bonus DROP CONSTRAINT idcategory;
       public               postgres    false    228    4789    224            �           2606    16461    bonus idpartner    FK CONSTRAINT     }   ALTER TABLE ONLY public.bonus
    ADD CONSTRAINT idpartner FOREIGN KEY (id_partner) REFERENCES public.partner(id) NOT VALID;
 9   ALTER TABLE ONLY public.bonus DROP CONSTRAINT idpartner;
       public               postgres    false    4781    222    224            �           2606    16447    nach_bonus idvol    FK CONSTRAINT     �   ALTER TABLE ONLY public.nach_bonus
    ADD CONSTRAINT idvol FOREIGN KEY (id_volonter) REFERENCES public.volonter(id) NOT VALID;
 :   ALTER TABLE ONLY public.nach_bonus DROP CONSTRAINT idvol;
       public               postgres    false    4785    226    225            �           2606    16407    account roleid    FK CONSTRAINT     v   ALTER TABLE ONLY public.account
    ADD CONSTRAINT roleid FOREIGN KEY (role_id) REFERENCES public.role(id) NOT VALID;
 8   ALTER TABLE ONLY public.account DROP CONSTRAINT roleid;
       public               postgres    false    218    220    4779            O      x���Ync�r���]x)�<��qa��0��QE�$(J�����C���k��A��'3#�!"��y�qx>���zZOO����~Է7c��풳ݘeRXٌV�s+��M����X�L&��ʲN7ӵ/5��̮�������s8��ٹ^�蹩tV����
E9ז�5���C�z����8v�.vL�V�]����TeF4�x׊[&�]}�����8>�?���Ô������]Jk&��Mi|��D]R�s��	�+yV�uT&�(����x���e.�Wau��^�q�Y����!����Jo�UoR�Cg���5���u��ǲ!�%1��z�;ů���j!P������ls̏Z�U��BX��6c.�&�?p3��J�(ݸ�}�ʚa��k��VU�Y~k��>��w�_����b���a����T��s��tw%���)�EVQ�^S�eX��E�R�Jl1�k�fw��}}���w�,��8���1�%�'�J���Ч�&�����A�^�P�b�A�8Rhv��+q.Y0?���m~x����T˹ԡcs�67�M�OM�՜���"'�5��՘����Ј�vo��,z;��n5]o]N��H��G�D��i��� �v��H��d'�zUy�����hr�.	�w��������~<sB�Y`s�y�^�$�p��B�-�Ջ�si��a��I�Z�jT���T�z6M�����̗)���*L/�P�-��p�朝�$)�K!Lk�������8U=祫�&G�D�D*�c>?~�_O�:1]
������j��Ē��˶͡ۊ��Tc%��Q��,�uo�D%P�}�?����pb=��m��t�k���3�VrkV-�Thl�~P����������	�w�x�/�k�\	��}%
fz3�2&�,%�Uӓ 5D۷t�X��$��}Uʓ�TA20�>��*_B43��{V�n�����S�8��}E��4z���<���U�'R�4WA���Y�^Y���U��d��D3غ��P�&$�KO��)���M'��}<ױ��~J���sh���Ѝ�`٨��S��<͚��Qc��+�F��O�Pr��n�L�V��8��j�������#��/����Z|��:�z*T��/)��_�[�1V�1����?�����@�X�a$����w�������eq'd���B9���̖_�2  ��{n�:���a�.A��>���߿Ҋ��8�)$ZM*%�J[D�Ъv�%��(y�g���8|N��W�.6
�"�K4G�UU����k�1$���緭j ������$�u�F�n�q�Mɜ�.kԀ��= ev��o���jٸ���}%j{"=�P�`�5��Jh���$;�ev��7�H�tK�t_��2m��+X��3�N��(�Pg�c�EY�����c�6��T��#�Y�~t�ǤJS��t'����z��Q�Dr��:��o&�F�c�
)���uE�����D�T#�,H��|5����8��b}F�;˵j���$%�� �[�Z�� &J�RI$�VHY�W��K1yd�������L*�X�_u5ĉ�����M�9_�"�W�]����~�rEX[kgdV-� i�vX{ѡ�Cۋ��S���Ξ��zb]�B_ZL���e���y?>t�]pA�W�Z��Ps9��$�c�|�=����Yى��lF}�o� �W�~u�>uEQ"H2-P�!� a�l��;R�ǹ��.�wri���69#�o*8Ɂv���bv�w���������:��I8ڤ|��tOY��릷Z2�0
�̏?���W����:F3�9�"-R��sD��C< oȏ��&"��ܩu� aJ9��&��|epl&0`��c�U�λ�ʓ�}�:�B�{E5��iuc�w�(a�4a���|DT	�;�.v4�r_��-��m-�dc��(�F=¨D�M��NJm#�)�'���t(Sݭ_~��%¤��`E,��Q˝��p5Xme*�!�`#{U<N��λ���B8~�� ��J
ȥĄ�� �Y���Z�8L�ٹ5�D�n��*�W��#��J�D�CX GG�U��
�n�Z��1 ��E@�P6_�X�O�է��b�Z�fNԻ���*[�1�E���~<���H�l�+Q�&	YE��� �P $�8c�c�V��^�&��*��n��M]	U)S)���̹���6wP����G��hJ�%#����P��Z�V�c��]4����ڼ��>[t��.���:1TGo�i��GW���'������g�-��
�s0lêF��]ϣh�0��l�)Q�M���6� �g�*cp8��<���B;$���4?��#��,L��,T&5"\`��TY�����&J��ק���翈��Q��c�).t�tp�
1-<�9����Ѝ-;����7�����t��*N�$�]Cҩ�tĆ̪�~ ;vp�S}��I��<�O��ǋ��?��vv�����b��_;S�r�0J2�h�O����;}���_����8��'�"��R��y�L�e�4���m�`,z����>�����G?��ѹ��ϭ�m����?o���!Q.��2�<��]U{���;�w�8����ӹ�<Ix2tbČ�hKG��,�d�H!-y�$��?�N�c����$��C�U`�/Iuʎ��Z����o��nL�_)��
�^�i�������Q��l�l�ɍ�>]" 
Vki�jvj�k��hO6aU���|�'�rê <�;��J��]I�4�g��^�n�/9Y�W�(.���]^�~ٟ���G}ëΏ|�N�Ꞃ�`B	��1�Xt��ڭn	ܚ�M���"ㆴ��L�J���:Ui��8��]��mE�ni',̝��l��_B&�d� �s�.��x��*ŸU�/�ʒ>b���
E,�V�#�5�����/?��c?�\Mdf�c��
a�Y)��!���� N_Z���⚿u	�N�!��d6>�XRm%�n#:Ù�Iˏ��������|qc�% f	r����H�A�- {	e%ӥW��t�@j��IA�(KmL��Z�#���T�i�=���i2�N bZ�GȜg �@��-A�yβ8���7�,v���K�ҿ�Ev,	�݅_5�}�׳[��$y�(��F�E���Y�-Y���_�qz�~ʍ��;ӏɉu�sn9Uq�/�X�b�$�Y�H'ek�ݠc�m(Yp�Ug����\#���lyF�7�H��uK"��b�	G����޾�߾}߿�x(��\ļ�Y�Mv��c2�� �C��k6צу��5�&O���MW��}5mꍋ"��+����*#�~�f��q"�ν\[qi��xT���5z�E�������h;'N��W�4k+�F�P]�u�#`��2	�ᢟlV��*�8��'�x����:unl��ō�������
M��!ʹ�Te��&�)���[Cʁ�0���ep�tx~o���C�jl\��Fvx(����Pe�mK��\�izG&�2���% ���l��@�v�p�UT��LP-�/�ĖB2�<]���KZ�Z�'+O [���
��Ű�Fx���7��'e5LK^r���F�
��h���W���P;=X8�o���i�B��55�j�\'�v�-��e[�Ӈ
�!nX^)s�����mвP������I�!a�ejt���8�օ<ZȘ��h`�f�`��t��uu�ZU�r�ټq�Ώ�SI�a�}����~�qP�Ԙ�R*�gR�br�);U��;>�)G8�w�0���$%�����K(ݘ(K
�E�N�^��GzŅ�*MvIBqV+Y�P�V��P����|:��	U��F_��#E=�]v���N�[�5�>�52�m��zJ}�����j%���^u����26��ln�6`��"���F����ipMȀR���Xh�dV���x��ŜGgę����.5$?P��\$APt�7�-e��2 �"U�L5������L��+ �n��mv㢊F�v
�ɝ��j��	 }A�J6O=e�	@`\�H�
M���,�S��F�i{��Q:땝� �  4���G�B�3��\�q�j���V%���V�?O�[5��mh��k�>��9a��gD� >Y�2ID�%��=r�VaQ����
� ������E���f<���:���iS�)c�"l��v��ɞ(����,KC�BS������h�P7MuR;A��\b����J�Ta�ݮMzBe)v��}�XE�L�"�|R�ef	��F�o���'9�/]aOj���λl��27r�d�)��Ph:��~�i\c��Ymn+�_���������u��+X2�V@h�
9.a06 ��=˼u:<�܋HP ����M(M�D�=��u\��*��Р�&Vw�&���U�T��O�J�
�Uc�$6�|��d`���!���#�r! �O���� �h�D�D���C�]�Qe0��j!�F�Q(���_��qr$�їTM�ؚ�\�)�%�6�Yҥ�U��d��d�x����h)�u���y��[��s�:8� v�Ҁ�.hŸҦr�ŷJ�Bjùx�i�S}B�!�����r�:+E'rR��?�~�?��Bڀ����pR^�{��A��{�26L��yv 7���� 'SFB		��u���ir2pB	!�勨��ɠXѺ>"�P*QS�������~� �mq� OYX9��m9]d�Ŏ!D�V�{H�d}V�W�u(OD�V�qN��Z��	Y/��Tf�����0;ˣ�]�!>4�s�l?n G#"�C#�`�A �Ts1�١��Rc���'֩U�|�C+`���h�=�!����D<@�x��b����@��y�$W����q���
 ���מQܯ��}��M�����nѣ����`+yb���7��	s.)O��n9��( �����W#������	��,.��B����|Aߨڒ�6��QI��(B5>8�E��`���R��M��F�'��9���˫!|�������c�4��I>ب�c�����ۈ�$���BN����_7�l��OIZ�JYK�����-��aK'�'�&����v��߿�ܐ+H�N��g��32���'zMm�Y��p�X@8�3;@�5�����1"2�o�����2��\�Fj�㤡Ct�=::�u���hc�|gt��7�������� '�{���ދ�6n!+�6��s
�C�N1��?�U�9�f���w��_~��5Y��@f�<[ݻh����l}���rl�%�TE)rR�/8�d����̻}��xoA�L�y�\��l-R,}L��JgwJ�;���E��5�<�]�@����e2tckY���f��C��vy��Fv<.]:O��E�B�v5[8l@LWo�'�;պZ�
�h�V�*4�ƣW"�=���c��V�`�LU�U惡T��H�2��C�a��pY;@Ψe!ut��8�����n� ���\����/>�a�X.#��l��עW�x	�j�NŮ͜ae�;��$Q�(
���Փp�&r3%~"4�����Ѝ����r���cطn�L��������U�J����sF�P�To^��I�q�y:tcl��W���U�Ym!�S�I`V� �*0b�l�̷XG�F�����Z �^���l���JZcj)���)Pl���ٴM��*U/$Y��5*0��
!#�,�H�k�}�]�%R�%�E�ƕ#gӤ�Vgײ�q@L�qc,�1�d�j�n�\�&�/�ku�8�@��ay�`3,G�ץ��͐6�c W����m]2��$1�&Ic�z��s�4i�:N7�t��4_���[D��k(j� =�G�L�^�����[����O�t��t�nй�&�R��O,@�����z�:��Ȕ	��ұ͈�ClҙZM�?�P��t�~\ڐ��Lo²�y��L\`��l!��WF��O�e& � /}�\~��ύ��Y�J ��O�B�x��rʃD��fԜ� �Gv.��L:3r.F ��K;��w���: W0��^�~�/��Ƃ��#�@�1kQ�n-��M,�e1�$ئ�s?��v��gl��X�f�
|\	�L��
rm�Y�[�~*��`\��Q?u��� ��_�K�����~)z�5�K6KF�K�Q0Nr2#�)�v8A��  �L�>I!<q �ק�	�y|u�4�\��@Α8�&N���q���5��*�>�����Z��Ӵ��;�������{Mg�v�u�	=z�"_�Ϧ�D�䮌�ri�~�v��3�S6N���qm(�nv!��n���]�5&��6�р򨽙U���N��[��!(Pu�Q�/G�]��y{ųC��a`|ȫ$�;
eI"lԹ�ߴ��Vzl].�I�q�5�Bہk�L��m�r�{]8�et�B��Kv��k!jim ڀ\�ഹ\���E.�LZTZ
g{� u�G4��n���r^i>{i��Uq�@��p,;"t�U�Ҳ�W�*�H�P��䬈�Rvg��O���
MC�5���#V����C仭+�:�e�:��D�s0�A��l}pZ�۩��y��Ľ�k�g��3�O��O���A�rL�� ��dr�ܢ�ƈʚ"VZ�2@��')}�� �ku9|`-���=:JR�,Hsܡ�Y�d����Nn,r���Э�,��w7�D���`���/s� x n�E�C?�u��]H�^��2�+Bg��R��)T2��v[������ ��5k\}X���'zl���m�E��z�K����UB�aZǒk�N{�����*v�]c�+r�Q$�DZ56LG7��L��u׮!���+Q�0�@dWPqjh�(a�Cގ��U�p�Q��V�i"Hk�!!�-��F��T��Ȁ�~�rq�m���\�c��$���~}>o��� �4�gΈ����p�������Nq&��-�S^N,8"%�v2��K����x|�?�|�k��v4x Ť���L�Z6���I�u1dt1N೽�ki���.�TD�������{+Fìa���� ='��鶬$�qrW�n^��Q���4� ��e~A�"�����c� x�<<kG�"��'�S�y6xƽu͇�$� K�[�&F��	ҠR����s/�]�>n�g ����B���v����P&�V f;䝿9���@LΐC��A��U�����7٭������Y�:�k��Ր)�&8_k�[�Q�I2y��qC�4y 4���K#���.y���(	�#	��e]!�`$H��������XNi74���ǚI�ĸ��z����]8Y���?��Xj�	���ř5���dJ�p����&F�<���m�z����׻$���f�3��3/>p	m�f܄hDPM$R�v#,�
���6��޴
3��ra�y��:�7��'6|� �'�F]&�_
y7;t�)	���~����@�L�?c9:&����z������(Ҫ�7Oa.��\}���p8�(ov�&JPP�E˗U��gL����y��m�v�:h7ݳ�mDl���D���Ɂ���P��^�4K�u�ܽ\�	�z�"U���\G�)���,���#�����B;Ws�?�W$��L81���L�^��?��6��8}�Ͽ��F�f8b�m0�2In�a�QI�Po�<��2�Fl!H�S�
a�_Ќ����7ۍ0T��H�G�l��l��L68�����=�2�fx�$�8FUE&�NpN&�^hƚ/1x~/�v�J��5�r��z[W��21۹�r��z$���vBr�2��8������ߏ��g��      U   /   x�3�4估�®;.l�MU�B�\F	ct	��=... |I �      Y      x�3�0�ˈ��D.c���b���� Bb�      W   
  x�eֻ�\1Q{^.��g�I(��?�齖A�ǻ��g��~��g|?}�O_��o���XoM�*��pwa�pOa
�c��h�Z^��(�(�e-
/�Z^��(�(kQxQ֢�S�N-�^tj���3�g��x� �qϘ�3�q�F<c'�q�8�g��x� �qϘ�3�	{#���8�g��3�x�E<cϸ�gL���ȷ=�|�q�5�x�E<cϸ�gL���؉g�3N�o<�"�1�g��3&�x�o#���8�g��3�x�E<cϸ�gL���؉g�3N�o<�"�1�g��3&�x�h�3v��x�ϸ�g�7�I<�!�p7�;���A<�$���3.��x�M<c�x�'����;�x�I<�g\�3�x�$��OX7C�3v��x�ϸ�g�7�I<�!�g��؉g�3N�o<�"�1�g��3&�xº*���8�g��3�x�E<cϸ�gL������v�Y�{~�<��e�
�      S   0   x�3�0�¾��x��.l��L����[9M�b���� a2�      Q   X   x����0��}�h���0����+x��K��
��x �����G�sab�ń�hc���4�s������P���T<R��_ͽ�}�9�      V   �  x���M�����S��юP@�.��0"eY��"$��r�ג��FjͨC#��B���2?	Tu������0( ��{�4a�-�\n���^no�n�O����i��S�cw�f��њyg������f��w��̄�[�[���we���S����4���;���vo#�u2�[�_�_��y��Ǜ�ox�&3c�s#>�9N���<��0�|�F|h�W��w�f|�<,����9���Ɩ�!?�@Ç����g���	���f�|yzo�O�	>��h?�i�~s��[CD�w
��7{��LA&��篗��9b�;y��ָRL���B��~���$C����r�>�/�1&o���F�	�N�jϥ�tb��{:<�-�b�-�����~�Q�ǆc�v��j���-�������L੼�����C_ރ�E�Z�D�1q���*���a�� ��]y���4���eփlU޷c9Ge��era�쁖�|�F� ��HyTL�	�~�����D����!�g	 Ľ�fE�������c>�zAyjtf��� 5Tڢ�^8FI��4���u��W�)�_���3̹(8M��(,��� ���s�BU}��Hs�gW#;.qƚ��T�(��W�՟������9�+�(��E� �&�?x�(�b���a�����n��� ��=`�T��[2��0���U�pO/��,�6�,k3� �XK�B.�<=h:�����Q?߄i���8%���"
����K��y�Ϥ�����U3n!
Fq:R3�'�[�|���E�>ơ��RK8�O���`�QK�.�Ff����<p���	�R�=@�*>��XbI��ַ}�;u�|>�i)K9����5�N���%.?	�|2�P4��G�2�N� ceӓ1 ��(lby���52�}j�uV��U��
���e:��)�Z��Gʃ����6���;9(!�X�����#�S���Z-�,b�)v�9�]�L�v�2�,?HN����¬87� Ǿ��!��,�?`L^V
��N��s�!T������P�2P����w��z+Ϯ�r<�[p���Z�C�)Xue�_e_%����fZ�QBs�L2��'�%��{��d�R��8��̌�0a�@-�Q�b`���z�@�,?�B*_��oϢf����HR��v�Qx�wO���{��HQ<��:�Ӷ���Ok��cFEl �yZ/�:1��m��3~���=V1T~#ې�j���:}�@Wylk�vb�@�dx�������+����F��#�.�W���ۍG>�Y�/��aR�;�İu�ep�_~����?ђ�p�Tس� .3���|N��L>Ɏ���I���E�cd��A-�E��/�2�G�>�bk�L���DC�#g��#5iT�'��djf�sz}Վ����l�9p�F����r,�c�>ٌ����xf7�FxF1�o���{^��=`1*���A�~��/��V���W�5���������^��=VXwUۑz���n��<�׷F��i0Ji�e:�B,�����xR���Nܒ��VH5A^���3F�x�P���r�@*k�S�D�{}q��x����rk�Pl=���'��g�[���%���?>֒^1�=>�V:�@���Z�%sQ/Z� ����IJk�LKޘ�<=웘�(7*�5)|�VHE!J��B�"+���T.5s�H
k�S���y�F�G���>��
�(^"�c5�f�{�\����f��BG��Gٖ�n��T.*u,#��2th�]�k6:�tv����W@�JW]z��Nx��7�1>0I�����=R�:{BsB+������Nv�u64A�G�l�P�z'��y��Ҹ?��"�d���i�3?*n����R�x���4�7l���������5��C��:aיU&�G��1��kh��̏�ى���f��Y��-՝Yz�#�:ަip�6i�-�L�7';��4ꏤ��I������6*rI��
B.��zF>�/�Ǻ][^��V�t��B<��g�Mgs!P(*>���U]��+��7*�黕��x�Q�����ǌ�\3�����B�y�Ί����脖&�2�4x�RiT�kMf�LﾣP��脖&���K��N(���p�U��
!U�p��h�m�4���D����k=6�e�(\�C���Ds�P�N�^s�!v�Q��휡#��}o�P�I�^�0�����h��67�{��C"��{�ԙ
s<�&��I�G!Eй�N�[��wD�35L{�Ɓ��5
�(D�޶C���#�d(FC�WDǁ�/�(D�~���t��!%���V�E	�y��6Or�S β�$����j�u{d�.�P���.��o��	6~)��=)���5��c<��r#�:t�)��P>i��V��rh��&M���	Ȇ�I�8�F:�w?�R�t�s��̄e����w������<��ف����:�L86�OZ����{a%��ni'�B�	Ć�I��ؽ�z!ݻU�[m�]2��Rj�� �Q��Vp~�%�B��t�7����n��I�MZ�#�s:��7J�'�4����Ͼ�4Ü���f���Q� t��77��2��ǖ�*�1����s��� ��4:�]m�6�	>7�7k�f�N��p�f�[ֹtܬ�;��m���� wZ�6Х&�f��$���A�Fi�����mt�	�Y�=�A�
�6ʢS�5�*y�	�Y�:����!%i��j�e�����/ߦM��A�G��TxC�Y�fbf�*/�9�0�aT���&� �(���6�h*A�Gq���J{]@̄hE�,O q�Q�ήi��2���H�Z�١�(�pN7��Dx�|��.�hE+8��!�\T��	w|���`�����Z����Z�V��`��)}'5�J��-��6�nm�b9���������[��Jö5nm�Z9J�:��tZ�o�Ʒ��u�ls*�Z�Gv�hxr��
�=c�s[V�@��D����KJ-w��}J��q[f����D��|��4[�rQQ��x�Yk�\���_�;p�F5�&�f���?o�b�����5)��䢲��cE����R���Ro��EEѹq�Ö-.��`Ek�D�4Z�pQ)���[����C�Ԕ��R�m.*I�o�ћ�_bC�iFn��+ɭ.*I�$���r�/��Z��Ջ4ZnwQQj��IEm/+�V9�|�Y��~�Eǽ���.���7j5��{%�����*�o�B�\��q�Vd��Cn{Q!�طNq1[.�e&4�rs�ɽ/���t�^'��0�2Z�{p�E�QI���N􄜹��
�Ԗ����.���u��isA0�Z��%|ȍ0*R�6ש.f���u�uyVq�Fej3�:ɓ��d�{~{���0*V�<��.����iUgH�.wĨH��������c>��|���^�Q��������F7��3)������Nu5�.Lm�p��"@�\�C�G��:��\�д���i��.�M��u���tai��ɋM$�wr���Ԧ�u�u�(gVZ�ٽ�����2*O�Q�p!�.���J;��7+L"=�n���E�z!�.���J����0�*�ވV��օ��ei�_Q�8�uF�ѩ�>�W��"s���E~m�N�Q��캭͓�iд3���a�dJ�J���]˱�9N�>A���ɢL6v9���j�]P͡�v|q��P�µiv�ꉙv�6k�3H�A�TvNn�Q��3Պ�'��L����,��F�['��r]ɷ�9�����{g�dV&��|[���)w�9�T�C�+:�;lT�ֆh��f��D��}7Gq1��~A7�J��5�s�w�7�Ԥyr7��]6*�[%���i��.��ɽ6*�&���iw�i����6*�[%���ig���*!}�}�]��A�v�E������v�w�2s���e�@U���afcV���	������^4�%��ѿ�rr�����;���r!���g����Gg     