 
 R e n a m e r V e r s i o n   = " 1 . 0 "  
  
 t r y   d e s t r o y d i a l o g   r e n a m e r   c a t c h ( )  
 t r y   d e s t r o y d i a l o g   r e n a m e r _ h e l p   c a t c h ( )  
 r o l l o u t   r e n a m e r _ h e l p   " H e l p "   w i d t h : 1 0 0  
 (  
 	 l a b e l   H e l p   " - - - - -   H e l p   - - - - - "  
 	 b u t t o n   b t n _ O b j N a m e   " $   -   O b j e c t n a m e "   w i d t h : 9 0   a l i g n : # c e n t e r   t o o l t i p : " I n s e r t   C u r r e n t   O b j e c t   n a m e "  
 	 b u t t o n   b t n _ M a t N a m e   " @   -   M a t e r i a l n a m e "   w i d t h : 9 0   a l i g n : # c e n t e r   t o o l t i p : " I n s e r t   C u r r e n t   M a t e r i a l   n a m e "  
 	 b u t t o n   b t n _ N u m b e r   " #   -   N u m b e r "   w i d t h : 9 0   a l i g n : # c e n t e r   t o o l t i p : " I n s e r t   N u m b e r   t o   N a m e "  
 	 b u t t o n   b t n _ c l o s e   " C l o s e "   w i d t h : 9 0   a l i g n : # c e n t e r   t o o l t i p : " C l o s e   H e l p "  
 	  
 	 o n   b t n _ o b j n a m e   p r e s s e d   d o   r e n a m e r . e d t _ n a m e . t e x t   =   r e n a m e r . e d t _ n a m e . t e x t + " $ "  
 	 o n   b t n _ M a t N a m e   p r e s s e d   d o   r e n a m e r . e d t _ n a m e . t e x t   =   r e n a m e r . e d t _ n a m e . t e x t + " @ "  
 	 o n   b t n _ N u m b e r   p r e s s e d   d o    
 	 (  
 	 	 r e n a m e r . e d t _ n a m e . t e x t   =   r e n a m e r . e d t _ n a m e . t e x t + " # "  
 	 	 r e n a m e r . s p n _ n u m s t a r t . e n a b l e d   =   t r u e  
 	 	 r e n a m e r . s p n _ d i g i t . e n a b l e d   =   t r u e  
 	 )  
 	 o n   b t n _ c l o s e   p r e s s e d   d o   d e s t r o y d i a l o g   r e n a m e r _ h e l p  
 )  
 r o l l o u t   r e n a m e r   " R e n a m e r "  
 (  
 	 g r o u p b o x   g r p _ r e n a m e   " R e n a m e r "   p o s : [ 5 , 5 ]   w i d t h : ( r e n a m e r . w i d t h   a s   f l o a t   - 1 0 )  
 	 l a b e l   l b l _ r e n a m e   " R e n a m e "  
 	 d r o p d o w n l i s t   d d l _ r e n a m e   " "   w i d t h : 1 0 0   i t e m s : # ( " O b j e c t " ,   " M a t e r i a l " )  
 	 b u t t o n   b t n _ h e l p   " ? "   b o r d e r : o f f   t o o l t i p : " H e l p "  
 	 b u t t o n   b t n _ n a m e   " N a m e "   w i d t h : 5 0   b o r d e r : o f f   t o o l t i p : " C l e a r   n a m e   f i e l d "  
 	 E d i t t e x t   e d t _ n a m e   f i e l d w i d t h : 1 6 0  
 	 S p i n n e r   s p n _ n u m s t a r t   " S t a r t "   r a n g e : [ 0 , 1 0 0 0 0 , 1 ]   t y p e : # i n t e g e r   f i e l d w i d t h : 4 0   t o o l t i p : " S t a r t   f r o m "  
 	 S p i n n e r   s p n _ d i g i t   " S u f f i x "   r a n g e : [ 2 , 1 0 , 3 ]   t y p e : # i n t e g e r   f i e l d w i d t h : 4 0   t o o l t i p : " S u f f i x   L e n g t h "  
 	 b u t t o n   b t n _ r e n a m e   " R e n a m e "   w i d t h : 2 1 0   t o o l t i p : " R e n a m e   s e l e c t e d   O b j e c t "  
 	  
 	 g r o u p b o x   g r p _ f i n d r e p l a c e   " F i n d   a n d   R e p l a c e "   w i d t h : ( r e n a m e r . w i d t h   a s   f l o a t   - 1 0 )    
 	 b u t t o n   b t n _ f i n d   " F i n d "   w i d t h : 5 0   b o r d e r : o f f   t o o l t i p : " C l e a r   f i n d   t e x t   f i e l d "  
 	 E d i t t e x t   e d t _ f i n d   f i e l d w i d t h : 1 6 0    
 	 b u t t o n   b t n _ w i t h   " R e p l a c e "   w i d t h : 5 0   b o r d e r : o f f   t o o l t i p : " C l e a r   r e p l a c e   t e x t   f i e l d "  
 	 E d i t t e x t   e d t _ w i t h   f i e l d w i d t h : 1 6 0  
 	 b u t t o n   b t n _ r e p l a c e   " R e p l a c e "   w i d t h : 2 1 0   t o o l t i p : " E x e c u t e   F i n d   a n d   R e p l a c e   o n   S e l e c t i o n "  
 	  
 	 g r o u p b o x   g r p _ r e m o v e   " R e m o v e   C h a r a c t e r "   w i d t h : ( r e n a m e r . w i d t h   a s   f l o a t   - 1 0 )  
 	 b u t t o n   b t n _ r m S t a r t   " R e m o v e   F r o m   B e g i n i n g "   w i d t h : 1 5 0   t o o l t i p : " R e m o v e   c h a r a c t e r s   f r o m   b e g i n i n g "  
 	 s p i n n e r   s p n _ s t a r t   " "   r a n g e : [ 0 , 1 0 0 0 , 0 ]   t y p e : # i n t e g e r   f i e l d w i d t h : 4 0   t o o l t i p : " S t a r t   C h a r a c t e r "  
 	 b u t t o n   b t n _ r m E n d   " R e m o v e   F r o m   E n d "   w i d t h : 1 5 0   t o o l t i p : " R e m o v e   c h a r a c t e r s   f r o m   E n d "  
 	 s p i n n e r   s p n _ e n d   " "   r a n g e : [ 0 , 1 0 0 0 , 0 ]   t y p e : # i n t e g e r   f i e l d w i d t h : 4 0   t o o l t i p : " E n d   C h a r a c t e r "  
 	  
 	 H y p e r L i n k   h l _ e m a i l   " M a i l "   a c r o s s : 3   a l i g n : # c e n t e r   o f f s e t : [ 0 , 0 ]   c o l o r : ( c o l o r   2 0 0   2 0 0   2 0 0 )   h o v e r c o l o r : ( c o l o r   2 5 5   2 5 5   2 5 5 )   v i s i t e d c o l o r : ( c o l o r   2 0 0   2 0 0   2 0 0 )   a d d r e s s : " m a i l t o : / / t i m o t h y . h a l i m @ l i v e . c o m "  
 	 H y p e r L i n k   h l _ w e b   " W e b s i t e "   a l i g n : # c e n t e r   o f f s e t : [ 0 , 0 ]   c o l o r : ( c o l o r   2 0 0   2 0 0   2 0 0 )   h o v e r c o l o r : ( c o l o r   2 5 5   2 5 5   2 5 5 )   v i s i t e d c o l o r : ( c o l o r   2 0 0   2 0 0   2 0 0 )   a d d r e s s : " h t t p : / / d o t t i m o . t u m b l r . c o m "  
 	 H y p e r L i n k   h l _ d o n a t e   " D o n a t e "   a l i g n : # c e n t e r   o f f s e t : [ 0 , 0 ]   c o l o r : ( c o l o r   2 0 0   2 0 0   2 0 0 )   h o v e r c o l o r : ( c o l o r   2 5 5   2 5 5   2 5 5 )   v i s i t e d c o l o r : ( c o l o r   2 0 0   2 0 0   2 0 0 )   a d d r e s s : " h t t p s : / / w w w . p a y p a l . c o m / c g i - b i n / w e b s c r ? c m d = _ d o n a t i o n s & b u s i n e s s = N S 2 N F U H X 7 N C U Q & l c = I D & i t e m _ n a m e = T i m o t h y % 2 0 H a l i m & c u r r e n c y _ c o d e = U S D & b n = P P % 2 d D o n a t i o n s B F % 3 a b t n _ d o n a t e _ S M % 2 e g i f % 3 a N o n H o s t e d "  
 	  
 	 l o c a l   R n D e s t  
 	 l o c a l   o n a m e  
 	  
 	 f u n c t i o n   f n _ i n i t   =  
 	 (  
 	 	 l b l _ r e n a m e . p o s   =   [ g r p _ r e n a m e . p o s . x + 1 0 , g r p _ r e n a m e . p o s . y + 1 7 ]  
 	 	 d d l _ r e n a m e . p o s   =   [ l b l _ r e n a m e . p o s . x + 4 5 , l b l _ r e n a m e . p o s . y - 3 ]  
 	 	 b t n _ h e l p . p o s   =   [ r e n a m e r . w i d t h - 3 0 , g r p _ r e n a m e . p o s . y   + 1 3 ]  
 	 	 b t n _ n a m e . p o s   =   [ g r p _ r e n a m e . p o s . x + 5 , l b l _ r e n a m e . p o s . y   + 2 0 ]    
 	 	 e d t _ n a m e . p o s   =   [ b t n _ n a m e . p o s . x + 5 0 , b t n _ n a m e . p o s . y + 2 ]  
 	 	 s p n _ n u m s t a r t . p o s   =   [ b t n _ n a m e . p o s . x + 1 1 5 , b t n _ n a m e . p o s . y + 2 5 ]  
 	 	 s p n _ d i g i t . p o s   =   [ s p n _ n u m s t a r t . p o s . x + 8 3 , b t n _ n a m e . p o s . y + 2 5 ]  
 	 	 b t n _ r e n a m e . p o s   = [ g r p _ r e n a m e . p o s . x + 5 , b t n _ n a m e . p o s . y + 4 5 ]  
 	 	 g r p _ r e n a m e . h e i g h t   =   ( b t n _ r e n a m e . p o s . y + 2 5 )  
 	 	  
 	 	 g r p _ f i n d r e p l a c e . p o s   =   [ g r p _ r e n a m e . p o s . x , g r p _ r e n a m e . p o s . y + g r p _ r e n a m e . h e i g h t ]  
 	 	 b t n _ f i n d . p o s   =   [ g r p _ f i n d r e p l a c e . p o s . x + 5 ,   g r p _ f i n d r e p l a c e . p o s . y + 1 5 ]  
 	 	 e d t _ f i n d . p o s   =   [ b t n _ f i n d . p o s . x + 5 0 , b t n _ f i n d . p o s . y + 2 ]  
 	 	 b t n _ w i t h . p o s   =   [ b t n _ f i n d . p o s . x , b t n _ f i n d . p o s . y + 2 5 ]  
 	 	 e d t _ w i t h . p o s   =   [ b t n _ f i n d . p o s . x + 5 0 , b t n _ f i n d . p o s . y + 2 7 ]  
 	 	 b t n _ r e p l a c e . p o s   =   [ g r p _ f i n d r e p l a c e . p o s . x + 5 , b t n _ w i t h . p o s . y + 2 5 ]  
 	 	 g r p _ f i n d r e p l a c e . h e i g h t   =   ( b t n _ r e p l a c e . p o s . y + 2 5 - g r p _ r e n a m e . h e i g h t )  
 	 	  
 	 	 g r p _ r e m o v e . p o s   =   [ g r p _ f i n d r e p l a c e . p o s . x , g r p _ f i n d r e p l a c e . p o s . y + g r p _ f i n d r e p l a c e . h e i g h t ]  
 	 	 b t n _ r m S t a r t . p o s   =   [ g r p _ r e m o v e . p o s . x + 5 ,   g r p _ r e m o v e . p o s . y + 1 5 ]  
 	 	 s p n _ s t a r t . p o s   =   [ b t n _ r m S t a r t . p o s . x + 1 9 5 ,   b t n _ r m S t a r t . p o s . y + 3 ]  
 	 	 b t n _ r m E n d . p o s   =   [ b t n _ r m S t a r t . p o s . x ,   b t n _ r m S t a r t . p o s . y + 2 5 ]  
 	 	 s p n _ e n d . p o s   =   [ s p n _ s t a r t . p o s . x ,   s p n _ s t a r t . p o s . y + 2 5 ]  
 	 	 g r p _ r e m o v e . h e i g h t   =   ( b t n _ r m E n d . p o s . y + 3 0 -   g r p _ f i n d r e p l a c e . p o s . y - g r p _ f i n d r e p l a c e . h e i g h t )  
 	 	 r e n a m e r . h e i g h t   =   g r p _ r e n a m e . h e i g h t   +   g r p _ f i n d r e p l a c e . h e i g h t   +   g r p _ r e m o v e . h e i g h t   + 2 0  
 	 	  
 	 	 h l _ e m a i l . p o s   =   [ h l _ e m a i l . p o s . x ,   ( r e n a m e r . h e i g h t - 1 4 ) ]  
 	 	 h l _ w e b . p o s   =   [ h l _ w e b . p o s . x ,   ( r e n a m e r . h e i g h t - 1 4 ) ]  
 	 	 h l _ d o n a t e . p o s   =   [ h l _ d o n a t e . p o s . x ,   ( r e n a m e r . h e i g h t - 1 4 ) ]  
 	 )  
 	 f u n c t i o n   f n _ c h e c k s t a t e   =  
 	 (  
 	 	 i f   f i n d S t r i n g   e d t _ n a m e . t e x t   " # "   ! =   u n d e f i n e d   t h e n    
 	 	 (  
 	 	 	 s p n _ n u m s t a r t . e n a b l e d   =   t r u e  
 	 	 	 s p n _ d i g i t . e n a b l e d   =   t r u e  
 	 	 )  
 	 	 e l s e    
 	 	 (  
 	 	 	 s p n _ n u m s t a r t . e n a b l e d   =   f a l s e  
 	 	 	 s p n _ d i g i t . e n a b l e d   =   f a l s e  
 	 	 )  
 	 	 i f   e d t _ f i n d . t e x t   ! =   " "   t h e n   b t n _ r e p l a c e . e n a b l e d   =   t r u e   e l s e   b t n _ r e p l a c e . e n a b l e d   =   f a l s e  
 	 )  
 	 o n   r e n a m e r   o p e n   d o  
 	 (  
 	 	 f n _ i n i t ( )  
 	 	 r e n a m e r . t i t l e   =   " . t i m o   -   R e n a m e r   v . "   + R e n a m e r V e r s i o n  
 	 	 f n _ c h e c k s t a t e ( )  
 	 )  
 	 o n   r e n a m e r   m o v e d   p o s   d o  
 	 (  
 	 	 i f   r e n a m e r _ h e l p . i s d i s p l a y e d   d o  
 	 	 (  
 	 	 	 r e n a m e r p o s   =   G e t D i a l o g P o s   r e n a m e r  
 	 	 	 s e t d i a l o g p o s   r e n a m e r _ h e l p   [ r e n a m e r p o s . x + r e n a m e r . w i d t h + 1 0 , r e n a m e r p o s . y + 3 0 ]  
 	 	 )  
 	 )  
 	 o n   b t n _ h e l p   p r e s s e d   d o  
 	 (  
 	 	 c r e a t e d i a l o g   r e n a m e r _ h e l p   s t y l e : # ( )  
 	 	 r e n a m e r p o s   =   G e t D i a l o g P o s   r e n a m e r  
 	 	 s e t d i a l o g p o s   r e n a m e r _ h e l p   [ r e n a m e r p o s . x + r e n a m e r . w i d t h + 1 0 , r e n a m e r p o s . y + 3 0 ]  
 	 )  
 	 o n   b t n _ n a m e   p r e s s e d   d o   e d t _ n a m e . t e x t   =   " "  
 	 o n   b t n _ f i n d   p r e s s e d   d o   ( e d t _ f i n d . t e x t   =   " " ; f n _ c h e c k s t a t e 	 ( ) )  
 	 o n   b t n _ w i t h   p r e s s e d   d o   e d t _ w i t h . t e x t   =   " "  
 	 o n   e d t _ n a m e   c h a n g e d   t x t   d o   f n _ c h e c k s t a t e 	 ( )  
 	 o n   b t n _ r e n a m e   p r e s s e d   d o  
 	 (  
 	 	 i f   e d t _ n a m e . t e x t   ! =   " "   d o  
 	 	 (  
 	 	 	 u n d o   " R e n a m e "   o n  
 	 	 	 (  
 	 	 	 	 o n u m   =   s p n _ n u m s t a r t . v a l u e  
 	 	 	 	 d i g i t   =   ( 1 0 ^ ( s p n _ d i g i t . v a l u e - 1 ) )   a s   s t r i n g  
 	 	 	 	 o b j   =   s e l e c t i o n   a s   a r r a y  
 	 	 	 	 f o r   i = 1   t o   o b j . c o u n t   d o    
 	 	 	 	 (  
 	 	 	 	 	 o n a m e =   e d t _ n a m e . t e x t  
 	 	 	 	 	 f o r   j = 1   t o   o n a m e . c o u n t   d o  
 	 	 	 	 	 (  
 	 	 	 	 	 	 f i n d t e x t   =   " # "  
 	 	 	 	 	 	 i f   s p n _ d i g i t . v a l u e   >   1   d o    
 	 	 	 	 	 	 ( 	  
 	 	 	 	 	 	 	 n   =   ( i + s p n _ n u m s t a r t . v a l u e - 1 )  
 	 	 	 	 	 	 	 i f   i   <   1 0   d o   n   =   ( " 0 "   +   n   a s   s t r i n g )  
 	 	 	 	 	 	 	 i f   i   > =   1 0   d o   n   =   n   a s   s t r i n g  
 	 	 	 	 	 	 	  
 	 	 	 	 	 	 	 r e p l a c e t e x t   =   ( ( s u b s t r i n g   ( d i g i t   a s   s t r i n g )   2   ( d i g i t . c o u n t - 2 ) ) +   n )  
 	 	 	 	 	 	 	 i f   r e p l a c e t e x t . c o u n t   >   d i g i t . c o u n t   d o   r e p l a c e t e x t   =   s u b s t r i n g   r e p l a c e t e x t   ( r e p l a c e t e x t . c o u n t - ( d i g i t . c o u n t - 1 ) )   ( r e p l a c e t e x t . c o u n t )  
 	 	 	 	 	 	 )  
 	 	 	 	 	 	 n u m   =   f i n d S t r i n g   o n a m e   f i n d t e x t  
 	 	 	 	 	 	 i f   n u m   ! =   u n d e f i n e d   d o   o n a m e   =   r e p l a c e   o n a m e   n u m   f i n d t e x t . c o u n t   r e p l a c e t e x t  
 	 	 	 	 	 	  
 	 	 	 	 	 	 f i n d t e x t   =   " $ "  
 	 	 	 	 	 	 n u m   =   f i n d S t r i n g   o n a m e   f i n d t e x t  
 	 	 	 	 	 	 i f   n u m   ! =   u n d e f i n e d   d o   o n a m e   =   r e p l a c e   o n a m e   n u m   f i n d t e x t . c o u n t   o b j [ i ] . n a m e  
 	 	 	 	 	 	  
 	 	 	 	 	 	 f i n d t e x t   =   " @ "  
 	 	 	 	 	 	 n u m   =   f i n d S t r i n g   o n a m e   f i n d t e x t  
 	 	 	 	 	 	 i f   n u m   ! =   u n d e f i n e d     a n d   o b j [ i ] . m a t e r i a l   ! =   u n d e f i n e d     t h e n   o n a m e   =   r e p l a c e   o n a m e   n u m   f i n d t e x t . c o u n t   o b j [ i ] . m a t e r i a l . n a m e  
 	 	 	 	 	 	 e l s e   i f   n u m   ! =   u n d e f i n e d   d o   o n a m e   =   r e p l a c e   o n a m e   n u m   f i n d t e x t . c o u n t   " N o   M a t e r i a l "  
 	 	 	 	 	 )  
 	 	 	 	 	 i f   d d l _ r e n a m e . s e l e c t i o n   = =   1   d o   o b j [ i ] . n a m e   =   o n a m e  
 	 	 	 	 	 i f   d d l _ r e n a m e . s e l e c t i o n   = =   2   a n d   o b j [ i ] . m a t e r i a l   ! =   u n d e f i n e d   d o   o b j [ i ] . m a t e r i a l . n a m e   =   o n a m e  
 	 	 	 	 )  
 	 	 	 )  
 	 	 )  
 	 )  
 	 o n   e d t _ f i n d   c h a n g e d   t x t   d o   f n _ c h e c k s t a t e 	 ( )  
 	 o n   b t n _ r e p l a c e   p r e s s e d   d o  
 	 (  
 	 	 i f   e d t _ f i n d . t e x t   ! =   " "   d o  
 	 	 (  
 	 	 	 u n d o   " R e n a m e "   o n  
 	 	 	 (  
 	 	 	 	 o b j   =   s e l e c t i o n   a s   a r r a y  
 	 	 	 	 f o r   i = 1   t o   o b j . c o u n t   d o    
 	 	 	 	 (  
 	 	 	 	 	 f i n d t e x t   =   e d t _ f i n d . t e x t  
 	 	 	 	 	 i f   d d l _ r e n a m e . s e l e c t i o n   = =   1   d o  
 	 	 	 	 	 (  
 	 	 	 	 	 	 n u m   =   f i n d S t r i n g   o b j [ i ] . n a m e   f i n d t e x t  
 	 	 	 	 	 	 i f   n u m   ! =   u n d e f i n e d   d o   o b j [ i ] . n a m e   =   r e p l a c e   o b j [ i ] . n a m e   n u m   f i n d t e x t . c o u n t   e d t _ w i t h . t e x t  
 	 	 	 	 	 )  
 	 	 	 	 	 i f   d d l _ r e n a m e . s e l e c t i o n   = =   2   a n d   o b j [ i ] . m a t e r i a l   ! =   u n d e f i n e d   d o  
 	 	 	 	 	 (  
 	 	 	 	 	 	 n u m   =   f i n d S t r i n g   o b j [ i ] . m a t e r i a l . n a m e   f i n d t e x t  
 	 	 	 	 	 	 i f   n u m   ! =   u n d e f i n e d   d o   o b j [ i ] . m a t e r i a l . n a m e   =   r e p l a c e   o b j [ i ] . m a t e r i a l . n a m e   n u m   f i n d t e x t . c o u n t   e d t _ w i t h . t e x t  
 	 	 	 	 	 )  
 	 	 	 	 )  
 	 	 	 )  
 	 	 )  
 	 )  
 	 o n   b t n _ r m S t a r t   p r e s s e d   d o  
 	 (  
 	 	 u n d o   " R e n a m e "   o n  
 	 	 (  
 	 	 	 o b j   =   s e l e c t i o n   a s   a r r a y  
 	 	 	 f o r   i = 1   t o   o b j . c o u n t   d o    
 	 	 	 (  
 	 	 	 	 i f   d d l _ r e n a m e . s e l e c t i o n   = =   1   d o   o b j [ i ] . n a m e   =   s u b s t r i n g   o b j [ i ] . n a m e   ( s p n _ s t a r t . v a l u e + 1 )   ( o b j [ i ] . n a m e . c o u n t )  
 	 	 	 	 i f   d d l _ r e n a m e . s e l e c t i o n   = =   2   a n d   o b j [ i ] . m a t e r i a l   ! =   u n d e f i n e d   d o   o b j [ i ] . m a t e r i a l . n a m e   =   s u b s t r i n g     o b j [ i ] . m a t e r i a l . n a m e   ( s p n _ s t a r t . v a l u e + 1 )   ( o b j [ i ] . m a t e r i a l . n a m e . c o u n t )  
 	 	 	 )  
 	 	 )  
 	 )  
 	 o n   b t n _ r m E n d   P r e s s e d   d o  
 	 (  
 	 	 u n d o   " R e n a m e "   o n  
 	 	 (  
 	 	 	 o b j   =   s e l e c t i o n   a s   a r r a y  
 	 	 	 f o r   i = 1   t o   o b j . c o u n t   d o    
 	 	 	 (  
 	 	 	 	 i f   d d l _ r e n a m e . s e l e c t i o n   = =   1   d o   o b j [ i ] . n a m e   =   s u b s t r i n g   o b j [ i ] . n a m e   ( 1 )   ( o b j [ i ] . n a m e . c o u n t - s p n _ e n d . v a l u e )  
 	 	 	 	 i f   d d l _ r e n a m e . s e l e c t i o n   = =   2   a n d   o b j [ i ] . m a t e r i a l   ! =   u n d e f i n e d   d o   o b j [ i ] . m a t e r i a l . n a m e   =   s u b s t r i n g   o b j [ i ] . m a t e r i a l . n a m e   ( 1 )   ( o b j [ i ] . m a t e r i a l . n a m e . c o u n t - s p n _ e n d . v a l u e )  
 	 	 	 )  
 	 	 )  
 	 )  
 	 o n   r e n a m e r   c l o s e   d o  
 	 (  
 	 	 t r y   d e s t r o y d i a l o g   r e n a m e r _ h e l p   c a t c h ( )  
 	 )  
 )  
 c r e a t e d i a l o g   r e n a m e r   w i d t h : 2 3 0 