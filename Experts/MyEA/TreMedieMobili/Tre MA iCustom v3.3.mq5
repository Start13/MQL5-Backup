/ / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                                                                 T r e   _ M A   i C u s t o m   v 3 . 2   . m q 5   |  
 / / |                                                                     C o p y r i g h t   2 0 2 4 ,   M e t a Q u o t e s   L t d .   |  
 / / |                                                                                           h t t p s : / / w w w . m q l 5 . c o m   |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / *  
 R i s p e t t o   a l l a   v 3 . 2    
 -   s i s t e m a n o   l i v e l l i   d i   e n t r a t a   o r d i n e   i n   b a s e   a l l a   M A   v e l o c e  
 -   s i s t e m a t o   l ' a p e r t u r a   o r d i n e   n o n   p i �   s u l l a   s t e s s a   c a n d e l a  
  
  
 * /  
  
 # p r o p e r t y   c o p y r i g h t   " C o r r a d o   B r u n i ,   C o p y r i g h t   � 2 0 2 3 "  
 / / # p r o p e r t y   l i n k             " h t t p s : / / w w w . c b a l g o t r a d e . c o m "  
 # p r o p e r t y   v e r s i o n           " 3 . 2 "  
 # p r o p e r t y   s t r i c t  
 # p r o p e r t y   i n d i c a t o r _ s e p a r a t e _ w i n d o w  
 # p r o p e r t y   d e s c r i p t i o n   " D i f f e r e n z a   c o n   l a   v 3 . 2 : "  
 # p r o p e r t y   d e s c r i p t i o n   " A g g i u n t o   p e n d e n z a   d e l l e   m e d i e   m o b i l i .   D e v o n o   e s s e r e   u g u a l i   d a   n �   c a n d e l e "  
 # p r o p e r t y   d e s c r i p t i o n   " A g g i u n t o   B r e a k E v e n   % "  
 # p r o p e r t y   d e s c r i p t i o n   " A g g i u n t o   T r a i l i n g   S t o p   % "  
 # p r o p e r t y   d e s c r i p t i o n   " A g g i u n t o   O p z i o n e   \ " S t r a t e g i a   i n t e r v i e n e   a l l ? a p e r t u r a   d e l l a   N u o v a   C a n d e l a \ " "  
 s t r i n g   v e r s i o n e           =   " v 3 . 2 " ;  
  
 # i n c l u d e   < M y L i b r a r y \ E n u m   D a y   W e e k . m q h >  
 # i n c l u d e   < M y I n c l u d e \ P a t t e r n s _ S q 9 . m q h >  
 # i n c l u d e   < M y L i b r a r y \ M y L i b r a r y . m q h >      
  
 / / - - - - - - - - - - - -   C o n t r o l l o   N u m e r o   L i c e n z e   e   t e m p o   T r i a l ,   C o r r a d o   - - - - - - - - - - - - - - - - - - - - - -  
 d a t e t i m e   T i m e L i c e n s   =   D ' 3 0 0 0 . 0 1 . 0 1   0 0 : 0 0 : 0 0 ' ;  
 l o n g   N u m e r o A c c o u n t O k   [ 1 0 ] ;  
 l o n g   N u m e r o A c c o u n t 0   =   N u m e r o A c c o u n t O k [ 0 ]   =   3 7 1 1 4 0 2 3 ;  
 l o n g   N u m e r o A c c o u n t 1   =   N u m e r o A c c o u n t O k [ 1 ]   =   6 8 1 5 2 6 9 4 ;  
 l o n g   N u m e r o A c c o u n t 2   =   N u m e r o A c c o u n t O k [ 2 ]   =   3 7 1 2 7 7 7 8 ;  
 l o n g   N u m e r o A c c o u n t 3   =   N u m e r o A c c o u n t O k [ 3 ]   =   2 7 0 8 1 5 4 3 ;  
 l o n g   N u m e r o A c c o u n t 4   =   N u m e r o A c c o u n t O k [ 4 ]   =   6 8 1 7 0 2 8 9 ;  
 l o n g   N u m e r o A c c o u n t 5   =   N u m e r o A c c o u n t O k [ 5 ]   =   6 8 1 6 8 7 5 3 ;  
 l o n g   N u m e r o A c c o u n t 6   =   N u m e r o A c c o u n t O k [ 6 ]   =   8 9 1 8 1 6 3 ;  
 l o n g   N u m e r o A c c o u n t 7   =   N u m e r o A c c o u n t O k [ 7 ]   =   6 7 1 1 3 3 7 3 ;  
 l o n g   N u m e r o A c c o u n t 8   =   N u m e r o A c c o u n t O k [ 8 ]   =   6 2 0 3 9 5 0 0 ;  
 l o n g   N u m e r o A c c o u n t 9   =   N u m e r o A c c o u n t O k [ 9 ]   =   3 7 1 4 0 9 6 1 ;  
  
 e n u m   E N U M _ P R I C E  
 {  
       c l o s e ,                               / /   C l o s e  
       o p e n ,                                 / /   O p e n  
       h i g h ,                                 / /   H i g h  
       l o w ,                                   / /   L o w  
       m e d i a n ,                             / /   M e d i a n  
       t y p i c a l ,                           / /   T y p i c a l  
       w e i g h t e d C l o s e ,               / /   W e i g h t e d   C l o s e  
       m e d i a n B o d y ,                     / /   M e d i a n   B o d y   ( O p e n + C l o s e ) / 2  
       a v e r a g e ,                           / /   A v e r a g e   ( H i g h + L o w + O p e n + C l o s e ) / 4  
       t r e n d B i a s e d ,                   / /   T r e n d   B i a s e d  
       t r e n d B i a s e d E x t ,             / /   T r e n d   B i a s e d ( e x t r e m e )  
       h a C l o s e ,                           / /   H e i k e n   A s h i   C l o s e  
       h a O p e n ,                             / /   H e i k e n   A s h i   O p e n  
       h a H i g h ,                             / /   H e i k e n   A s h i   H i g h        
       h a L o w ,                               / /   H e i k e n   A s h i   L o w  
       h a M e d i a n ,                         / /   H e i k e n   A s h i   M e d i a n  
       h a T y p i c a l ,                       / /   H e i k e n   A s h i   T y p i c a l  
       h a W e i g h t e d ,                     / /   H e i k e n   A s h i   W e i g h t e d   C l o s e  
       h a M e d i a n B o d y ,                 / /   H e i k e n   A s h i   M e d i a n   B o d y  
       h a A v e r a g e ,                       / /   H e i k e n   A s h i   A v e r a g e  
       h a T r e n d B i a s e d ,               / /   H e i k e n   A s h i   T r e n d   B i a s e d  
       h a T r e n d B i a s e d E x t           / /   H e i k e n   A s h i   T r e n d   B i a s e d ( e x t r e m e )        
 } ;  
  
  
 e n u m   E N U M _ M A _ M O D E  
 {  
       S M A ,                                   / /   S i m p l e   M o v i n g   A v e r a g e  
       E M A ,                                   / /   E x p o n e n t i a l   M o v i n g   A v e r a g e  
       W i l d e r ,                             / /   W i l d e r   E x p o n e n t i a l   M o v i n g   A v e r a g e  
       L W M A ,                                 / /   L i n e a r   W e i g h t e d   M o v i n g   A v e r a g e  
       S i n e W M A ,                           / /   S i n e   W e i g h t e d   M o v i n g   A v e r a g e  
       T r i M A ,                               / /   T r i a n g u l a r   M o v i n g   A v e r a g e  
       L S M A ,                                 / /   L e a s t   S q u a r e   M o v i n g   A v e r a g e   ( o r   E P M A ,   L i n e a r   R e g r e s s i o n   L i n e )  
       S M M A ,                                 / /   S m o o t h e d   M o v i n g   A v e r a g e  
       H M A ,                                   / /   H u l l   M o v i n g   A v e r a g e   b y   A l a n   H u l l  
       Z e r o L a g E M A ,                     / /   Z e r o - L a g   E x p o n e n t i a l   M o v i n g   A v e r a g e  
       D E M A ,                                 / /   D o u b l e   E x p o n e n t i a l   M o v i n g   A v e r a g e   b y   P a t r i c k   M u l l o y  
       T 3 _ b a s i c ,                         / /   T 3   b y   T . T i l l s o n   ( o r i g i n a l   v e r s i o n )  
       I T r e n d ,                             / /   I n s t a n t a n e o u s   T r e n d l i n e   b y   J . E h l e r s  
       M e d i a n ,                             / /   M o v i n g   M e d i a n  
       G e o M e a n ,                           / /   G e o m e t r i c   M e a n  
       R E M A ,                                 / /   R e g u l a r i z e d   E M A   b y   C h r i s   S a t c h w e l l  
       I L R S ,                                 / /   I n t e g r a l   o f   L i n e a r   R e g r e s s i o n   S l o p e  
       I E _ 2 ,                                 / /   C o m b i n a t i o n   o f   L S M A   a n d   I L R S  
       T r i M A g e n ,                         / /   T r i a n g u l a r   M o v i n g   A v e r a g e   g e n e r a l i z e d   b y   J . E h l e r s  
       V W M A ,                                 / /   V o l u m e   W e i g h t e d   M o v i n g   A v e r a g e  
       J S m o o t h ,                           / /   S m o o t h i n g   b y   M a r k   J u r i k  
       S M A _ e q ,                             / /   S i m p l i f i e d   S M A  
       A L M A ,                                 / /   A r n a u d   L e g o u x   M o v i n g   A v e r a g e  
       T E M A ,                                 / /   T r i p l e   E x p o n e n t i a l   M o v i n g   A v e r a g e   b y   P a t r i c k   M u l l o y  
       T 3 ,                                     / /   T 3   b y   T . T i l l s o n   ( c o r r e c t   v e r s i o n )  
       L a g u e r r e ,                         / /   L a g u e r r e   f i l t e r   b y   J . E h l e r s  
       M D ,                                     / /   M c G i n l e y   D y n a m i c  
       B F 2 P ,                                 / /   T w o - p o l e   m o d i f i e d   B u t t e r w o r t h   f i l t e r   b y   J . E h l e r s  
       B F 3 P ,                                 / /   T h r e e - p o l e   m o d i f i e d   B u t t e r w o r t h   f i l t e r   b y   J . E h l e r s  
       S u p e r S m u ,                         / /   S u p e r S m o o t h e r   b y   J . E h l e r s  
       D e c y c l e r ,                         / /   S i m p l e   D e c y c l e r   b y   J . E h l e r s  
       e V W M A ,                               / /   M o d i f i e d   e V W M A  
       E W M A ,                                 / /   E x p o n e n t i a l   W e i g h t e d   M o v i n g   A v e r a g e  
       D s E M A ,                               / /   D o u b l e   S m o o t h e d   E M A  
       T s E M A ,                               / /   T r i p l e   S m o o t h e d   E M A  
       V E M A                                   / /   V o l u m e - w e i g h t e d   E x p o n e n t i a l   M o v i n g   A v e r a g e ( V - E M A )  
 } ;    
  
 e n u m   f i l t r o P i v o t  
     {  
       N o P i v o t                   =   0 ,   / / N o   F i l t r o   P i v o t  
       P i v o t D                     =   1 ,   / / F i l t r o   D a i l y  
       P i v o t W                     =   2 ,   / / F i l t r o   W e e k l y  
     } ;  
 e n u m   T y p e P i v o t  
     {  
       P i v o t D H L _ 2             =   2 ,   / /   P i v o t   H L : 2  
       P i v o t D H L C _ 3           =   3     / /   P i v o t   H L : 3  
     } ;  
  
 e n u m   G r i d _ H e d g e  
     {  
       N o G r i d _ N o H e d g e     =   0 ,   / / N o   G r i g l i a   /   N o   H e d g i n g  
       G r i d _                       =   1 ,   / / G r i g l i a  
       H e d g e                       =   2 ,   / / H e d g i n g  
     } ;  
 e n u m   T i p o M u l t i p l i G r i g l i a  
     {  
       F i x                           =   0 ,  
       P r o g r e s s i v e           =   1 ,  
     } ;  
 e n u m   n u m M a x O r d  
     {  
       U n a _ p o s i z i o n e       =   1 ,     / / M a x   1   O r d i n e  
       D u e _ p o s i z i o n i       =   2 ,     / / M a x   2   O r d i n i  
     } ;  
 e n u m   c a p i t B a s e P e r C o m p o u n d i n g g  
     {  
       E q u i t y                     =   0 ,  
       M a r g i n e _ l i b e r o     =   1 ,   / / F r e e   m a r g i n  
       B a l a n c e                   =   2 ,  
     } ;  
 e n u m   F u s o _  
     {  
       G M T                             =   0 ,  
       L o c a l                         =   1 ,  
       S e r v e r                       =   2  
     } ;  
 e n u m   T i p o O r d i n i  
     {  
       B u y _ S e l l                   =   0 ,     / / O r d e r s   B u y   e   S e l l  
       B u y                             =   1 ,     / / O n l y   B u y   O r d e r s  
       S e l l                           =   2       / / O n l y   S e l l   O r d e r s  
     } ;  
 e n u m   T i p o S t o p L o s s  
     {  
       N o                               =   0 ,     / / N o   S t o p   L o s s  
       P o i n t s                       =   1 ,     / / S t o p   L o s s   P o i n t s  
     } ;  
 e n u m   S t o p L o s s  
       {  
       N o                               =   0 ,     / / N o  
       S L P o i n t s                   =   1 ,     / / S t o p   L o s s   i n   P o i n t s  
       M A                               =   2 ,     / / S t o p   L o s s   a l l a   M A    
       } ;        
 e n u m   T y p e M A  
       {  
       M A 1                             =   1 ,     / / S t o p   L o s s   a l l a   M A 1  
       M A 2                             =   2 ,     / / S t o p   L o s s   a l l a   M A 2    
       M A 3                             =   3 ,     / / S t o p   L o s s   a l l a   M A 3  
       } ;                      
  
 e n u m   T y p e C a n d l e  
     {  
       S t e s s o                       =   0 ,     / / T r a i l i n g   S t o p   s u l   m i n / m a x   d e l l a   c a n d e l a   " i n d e x "  
       U n a                             =   1 ,     / / T r a i l i n g   S t o p   s u l   m i n / m a x   d e l   c o r p o   d e l l a   c a n d e l a   " i n d e x "  
       D u e                             =   2 ,     / / T r a i l i n g   S t o p   s u l   m a x / m i n   d e l   c o r p o   d e l l a   c a n d e l a   " i n d e x "  
       T r e                             =   3 ,     / / T r a i l i n g   S t o p   s u l   m a x / m i n   d e l l a   c a n d e l a   " i n d e x "  
     } ;  
 e n u m   B E  
     {  
       N o _ B E                                           =   0 ,     / / N o   B r e a k e v e n  
       B E P o i n t s                                     =   1 ,     / / B r e a k e v e n   P o i n t s  
       P e r c O p e n T P                                 =   2 ,     / / B r e a k e v e n   P e r c e n t u a l e   O p e n P r i c e / T a k e   P r o f i t  
     } ;          
 e n u m   T S t o p  
     {  
       N o _ T S                                           =   0 ,     / / N o   T r a i l i n g   S t o p  
       P o i n t s t o p                                   =   1 ,     / / T r a i l i n g   S t o p   i n   P o i n t s  
       T S P o i n t T r a d i z                           =   2 ,     / / T r a i l i n g   S t o p   i n   P o i n t s   T r a d i t i o n a l  
       T s T o p B o t C a n d l e                         =   3 ,     / / T r a i l i n g   S t o p   P r e v i o u s   C a n d l e  
       P e r c O p e n T P                                 =   4 ,     / / T r a i l i n g   S t o p   P e r c e n t u a l e   O p e n P r i c e / T a k e   P r o f i t  
     } ;            
 e n u m   T p  
     {  
       N o _ T p                         =   0 ,     / / N o   T p  
       T p P o i n t s                   =   1 ,     / / T p   i n   P o i n t s  
     } ;  
      
 e n u m   S t o p B e f o r e _  
     {  
       c i n q u e M i n                 =     5 ,   / / 5   M i n  
       d i e c i M i n                   =   1 0 ,   / / 1 0   m i n  
       q u i n d M i n                   =   1 5 ,   / / 1 5   m i n  
       t r e n t a M i n                 =   3 0 ,   / / 3 0   m i n  
       q u a r a n t a c i n M i n       =   4 5 ,   / / 4 5   m i n  
       u n O r a                         =   6 0 ,   / / 1   H o u r  
       u n O r a e M e z z a             =   9 0 ,   / / 1 : 3 0   H o u r  
       d u e O r e                       = 1 2 0 ,   / / 2   H o u r s  
       d u e O r e e M e z z a           = 1 5 0 ,   / / 2 : 3 0   H o u r s  
       t r e O r e                       = 1 8 0 ,   / / 3   H o u r s  
       q u a t t r o O r e               = 2 4 0 ,   / / 4   H o u r s  
     } ;  
 e n u m   S t o p A f t e r _  
     {  
       c i n q u e M i n                 =     5 ,   / / 5   M i n  
       d i e c i M i n                   =   1 0 ,   / / 1 0   m i n  
       q u i n d M i n                   =   1 5 ,   / / 1 5   m i n  
       t r e n t a M i n                 =   3 0 ,   / / 3 0   m i n  
       q u a r a n t a c i n M i n       =   4 5 ,   / / 4 5   m i n  
       u n O r a                         =   6 0 ,   / / 1   H o u r  
       u n O r a e M e z z a             =   9 0 ,   / / 1 : 3 0   H o u r  
       d u e O r e                       = 1 2 0 ,   / / 2   H o u r s  
       d u e O r e e M e z z a           = 1 5 0 ,   / / 2 : 3 0   H o u r s  
       t r e O r e                       = 1 8 0 ,   / / 3   H o u r s  
       q u a t t r o O r e               = 2 4 0 ,   / / 4   H o u r s  
     } ;          
 e n u m   p a t t I m p L i v  
 {  
 i m p u l s o           =       1 ,  
 l i v e l l o           =       2 ,  
 } ;      
 e n u m   p e n d I m p L i v  
 {  
 i m p u l s o           =       1 ,  
 l i v e l l o           =       2 ,  
 } ;      
 e n u m   p a t t e r n C h i u d e O r d i n i  
       {  
       n o                                             =   1 ,     / / N o  
       y e s                                           =   2 ,     / / S i    
       s o l o P r o f i t                             =   3 ,     / / S o l o   s e   i n   p r o f i t t o  
       } ;            
 e n u m   F i l t e r _ A T R _    
     {  
       F l a t                                         =   0 ,     / / F l a t  
       S o t t o                                       =   1 ,     / / A b i l i t a   O r d i n i   S o p r a   i l   l i v e l l o   i m p o s t a t o  
       S o p r a                                       =   2 ,     / / A b i l i t a   O r d i n i   S o t t o   i l   l i v e l l o   i m p o s t a t o  
     } ;            
 e n u m   i n p u t M A    
     {  
       A l l _ M A                                         =   0 ,     / / A L L _ M A  
       M A                                                 =   1 ,     / / M A  
     } ;  
 e n u m   o l t r e M a  
     {  
       s u p e r a m M A                                   =   0 ,     / / t o c c a   M A  
       r i m b a l z o M A                                 =   1 ,     / / r i e n t r o   d a   M A  
     } ;  
 e n u m   d i r e z C a n d  
     {  
   / / N o                                                 =   0 ,     / / F l a t  
       c a n d N                                           =   1 ,     / / N �   C a n d e l e   c o n g r u e   c o n   l ' O r d i n e  
       c a n d N e S u p e r a m B o d y                   =   2 ,     / / N �   C a n d e l e   c o n g r u e   e   s u p e r a m   b o d y   c a n d   p r e c e d                                                                
       c a n d N e S u p e r a m S h a d o w               =   3 ,     / / N �   C a n d e l e   c o n g r u e   e   s u p e r a m   s h a d o w   c a n d   p r e c e d  
     } ;        
 e n u m   p e n d e n z a C h i u d e O r d i n i  
       {  
       n o                               =   1 ,                               / / N o  
       y e s                             =   2 ,                               / / S i    
       s o l o P r o f i t               =   3 ,                               / / S o l o   s e   i n   p r o f i t t o  
       s o l o T u t t e O p p o s t e   =   4 ,                               / / S e   T U T T E   l e   p e n d   o p p o s t e  
       } ;                    
 / *      
 i n p u t   s t r i n g       c o m m e n t M A S             =         " - - -     S C E L T A   M E D I A   M O B I L E   - - - " ;       / /   - - -   S C E L T A   M E D I A   M O B I L E G   - - -  
 i n p u t   i n p u t M A     i n p u t M A _                 =             0 ;     / / S c e l t a   M A      
 * /  
 i n p u t   s t r i n g       c o m m e n t _ S E M           =   " - - -   Q u a n d o   i n t e r v i e n e   l a   S t r a t e g i a   - - - " ;       / /   - - -   Q u a n d o   i n t e r v i e n e   l a   S t r a t e g i a   - - -    
 i n p u t   b o o l   s t r a t N e w C a n d                 =   f a l s e ;                                                         / / S t r a t e g i a   e l a b o r a   a d   o g n i   N u o v a   C a n d e l a .   ( C o n   " t o c c a   M A " :   t r u e )    
        
 i n p u t   s t r i n g       c o m m e n t _ P A T T         =   " - - -   P A T T E R N   M E D I E   M O B I L I   - - - " ;       / /   - - -   P A T T E R N   M E D I E   M O B I L I   - - -  
 i n p u t   i n t   d i s t a n z a M i n 3 M A               =       1 0 0 ;                                                         / / D i s t a n z a   M i n   P o i n t s   t r a   l e   M e d i e   p e r   p e r m e t t e r e   O r d i n i  
  
 i n p u t   i n t   	       n C a n d l e s                 =         1 0 ; 	 	 	         	                           / / C a n d e l e   t r e n d   p e r   a p e r t u r a   O r d i n e .   M i n   1  
 i n p u t   o l t r e M a     o l t r e M A _                 =           1 ;                                                         / / A p e r t u r a   O r d i n e :   t o c c a   M A / r i e n t r o   d a   M A    
    
 i n p u t   s t r i n g       c o m m e n t _ R I E N T R O   =   " - - -   s e   \ " r i e n t r o   d a   M A \ "   - - - " ;       / /   - - -   s e   " r i e n t r o   d a   M A "   - - -  
 i n p u t   d i r e z C a n d     d i r e z C a n d _         =           1 ;                                                         / / P e r m e t t e   O r d i n e   C a n d   a   f a v o r e :   N o / N � C a n d / N � C a n d + B o d y / N � C a n d + S h a d o w          
 i n p u t   i n t             n u m C a n d D i r e z         =           1 ;                                                         / / N u m e r o   C a n d e l e   a   f a v o r e .   M i n i m o   1 .  
 i n p u t   E N U M _ T I M E F R A M E S   t i m e F r C a n d   =       P E R I O D _ C U R R E N T ;                               / / T i m e   F r a m e   C a n d e l e                    
  
 i n p u t   s t r i n g       c o m m e n t _ C l o s P E N D     =       " - - -   P A T T E R N   P E N D E N Z E   D I S C O R D I   C H I U D E   O R D I N E   - - - " ;         / /   - - -   P A T T E R N   P E N D E N Z E   D I S C O R D I   C H I U D E   O R D I N E   - - -  
 i n p u t   p e n d e n z a C h i u d e O r d i n i   p e n d e n z a C h i u d e O r d i n i _   =             1 ;                     / / N O / S I / S o l o   i n   p r o f i t t o / S o l o   s e   t u t t e   o p p o s t e  
 i n t   n u m c a n d c h i u d i o r d   =   2 ;  
  
 i n p u t   s t r i n g       c o m m e n t _ E n a b P e n       =       " - - -   F I L T R O   P A T T E R N   P E N D E N Z E   - - - " ;         / /   - - -   F I L T R O   P A T T E R N   P E N D E N Z E   - - -  
 i n p u t   i n t             n u m c a n d p e n d e n z e                                                               =           7 ;             / / N �   c a n d e l e   d i   u g u a l e   p e n d e n z a :   p e r m e t t e   o r d . 0 / 1   F l a t .   M i n   2 .   M A    
                                        
    
 i n p u t   s t r i n g       c o m m e n t _ O S                 =       " - - -   O R D E R   S E T T I N G S   - - - " ;                           / /   - - -   O R D E R   S E T T I N G S   - - -  
 i n p u t   b o o l                                       S t o p N e w s O r d e r s                                     =   f a l s e ;             / / F e r m a   l ' E A   q u a n d o   t e r m i n a n o   g l i   O r d i n i  
 i n p u t   i n t   C l o s e O r d D o p o N u m C a n d D a l P r i m o O r d i n e _                                   =     2 2 ;                 / / C h i u d e   l ' O r d i n e   s e   i n   p r o f i t t o   d o p o   n �   c a n d e l e .   ( 0   =   D i s a b l e )  
 / / i n p u t   c h a r                                       m a x D D P e r c                                               =       0 ;             / / M a x   D D %   ( 0   D i s a b l e )  
 i n p u t   i n t                                         M a x S p r e a d                                               =       0 ;                 / / M a x   S p r e a d   ( 0   =   D i s a b l e )  
 i n p u t   T i p o O r d i n i                           t i p o O r d i n i                                             =       0 ;                 / / T i p o   d i   O r d i n i  
 i n p u t   n u m M a x O r d                             n u m M a x O r d i n i                                         =       2 ;                 / / M a s s i m o   n u m e r o   d i   O r d i n i   c o n t e m p o r a n e a m e n t e  
 / / i n p u t   i n t                                       N _ m a x _ o r d e r s                                       =     5 0 ;                 / / M a s s i m o   n u m e r o   d i   O r d i n i   n e l l a   g i o r n a t a  
 i n p u t   u l o n g                                     m a g i c N u m b e r                                           =   4 4 4 4 ;               / / M a g i c   N u m b e r  
 i n p u t   s t r i n g                                   C o m m e n                                                     =     " " ;                 / / C o m m e n t  
 i n p u t   i n t                                         D e v i a z i o n e                                             =       0 ;                 / / S l i p p a g e    
 / *  
 i n p u t   s t r i n g       c o m m e n t _ C A N       =           " - - -   F I L T E R   C A N D L E   O R D E R S   - - - " ;               / /   - - -   F I L T E R   C A N D L E   O R D E R S   - - -  
 i n p u t   b o o l                                       O r d i n i S u S t e s s a C a n d e l a                       =   t r u e ;           / / A b i l i t a   p i �   o r d i n i   s u l l a   s t e s s a   c a n d e l a  
 i n p u t   b o o l                                       O r d E C h i u S t e s s a C a n d e l a                       =   t r u e ;           / / A b i l i t a   N e w s   O r d e r s   s u l l a   c a n d e l a   d i   o r d i n i   g i �   a p e r t i   e / o   c h i u s i  
 i n p u t   s t r i n g       c o m m e n t _ D I R       =           " - - -   F I L T E R   D I R E Z   C A N D L E   - - - " ;               / /   - - -   F I L T E R   D I R E Z   C A N D L E   - - -  
 i n p u t   b o o l                                       d i r e z C a n d Z e r o                                       =   f a l s e ;           / / D i r e c t i o n   C a n d l e   a t t u a l e   i n   f a v o r   ( 0 ) )  
 i n p u t   b o o l                                       d i r e z C a n d U n o                                         =   f a l s e ;           / / D i r e c t i o n   C a n d l e   p r e c e d e n t e   i n   f a v o r   ( 1 ) )  
 * /  
  
 i n p u t   s t r i n g       c o m m e n t _ S L =                       " - - -   S T O P   L O S S   - - - " ;   / /   - - -   S T O P   L O S S   - - -  
 i n p u t   S t o p L o s s   S t o p L o s s _   =                             1 ;                         / / S t o p   L o s s   P o i n t s   /   M A    
 i n p u t   T y p e M A   T y p e M A _           =                             1 ;                         / / S t o p   l o s s   s u   q u a l e   M A    
 i n p u t   i n t   S l P o i n t s               =                     1 0 0 0 0 ;                         / / S t o p   l o s s   P o i n t s   /   D i s t a n z a   P o i n t s   M A        
  
 i n p u t   s t r i n g       c o m m e n t _ B E   =                       " - - -   B R E A K   E V E N   - - - " ;       / /   - - -   B R E A K   E V E N   - - -  
 i n p u t   B E               B r e a k E v e n                                 =         1 ;                             / / B e   T y p e  
 i n p u t   i n t             B e S t a r t P o i n t s                         =   2 5 0 0 ;                             / / B e   S t a r t   i n   P o i n t s  
 i n p u t   i n t             B e S t e p P o i n t s                           =     2 0 0 ;                             / / B e   S t e p   i n   P o i n t s  
 i n p u t   d o u b l e       B e P e r c S t a r t                             =   6 1 . 8 ;                             / / B e   %   S t a r t  
 i n p u t   d o u b l e       B e P e r c S t e p                               =   3 2 . 8 ;                             / / B e   %   S t e p  
  
 i n p u t   s t r i n g       c o m m e n t _ T S   =                       " - - -   T R A I L I N G   S T O P   - - - " ;       / /   - - -   T R A I L I N G   S T O P   - - -  
 i n p u t   T S t o p         T r a i l i n g S t o p                           =         1 ;                             / / T s   N o / P o i n t s / P o i n t s   T r a d i t i o n a l / C a n d l e  
 i n p u t   i n t             T s S t a r t                                     =   3 0 0 0 ;                             / / T s   S t a r t   i n   P o i n t s  
 i n p u t   i n t             T s S t e p                                       =     7 0 0 ;                             / / T s   S t e p   i n   P o i n t s  
 i n p u t   d o u b l e       T s P e r c S t a r t                             =   6 1 . 8 ;                             / / T s   %   S t a r t  
 i n p u t   d o u b l e       T s P e r c S t e p                               =   3 2 . 8 ;                             / / T s   %   S t e p  
  
 i n p u t   s t r i n g       c o m m e n t _ T S C   =               " - - -   T R A I L I N G   S T O P   C A N D L E   - - - " ;       / /   - - -   T R A I L I N G   S T O P   C A N D L E - - -  
 i n p u t   T y p e C a n d l e   T i p o T S C a n d e l e                     =         0 ;                             / / T y p e   T r a i l i n g   S t o p   C a n d l e  
 i n p u t   i n t               i n d e x C a n d l e _                         =         3 ;                             / / I n d e x   C a n d l e   P r e v i o u s  
 i n p u t   E N U M _ T I M E F R A M E S   T F C a n d l e                     =         P E R I O D _ C U R R E N T ;   / / T i m e   f r a m e   C a n d l e   T o p / B o t t o m  
  
 i n p u t   s t r i n g       c o m m e n t _ T P   =                 " - - -   T A K E   P R O F I T   - - - " ;   / /   - - -   T A K E   P R O F I T   - - -  
 i n p u t   T p               T a k e P r o f i t                               =         1 ;                             / / T a k e   P r o f i t   T y p e  
 i n p u t   i n t             T p P o i n t s                                   =   1 0 0 0 ;                             / / T a k e   P r o f i t   P o i n t s  
  
 i n p u t   s t r i n g       c o m m e n t _ T F M A   =                       " - - -   T i m e   F r a m e   S c a n   M A   - - - " ;   / /   - - -   T i m e   F r a m e   S c a n   M A   - - -  
 i n p u t   E N U M _ T I M E F R A M E S   P e r i o d P a t t e r n 1   =   P E R I O D _ C U R R E N T ;   / /   T F   P a t t e r n   1  
 i n p u t   E N U M _ T I M E F R A M E S   P e r i o d P a t t e r n 2   =   P E R I O D _ C U R R E N T ;   / /   T F   P a t t e r n   2  
  
 i n p u t   s t r i n g       c o m m e n t _ M A 1   =                 " - - -   M A 1     S E T T I N G   - - - " ;       / /   - - -   M A 1     S E T T I N G   - - -  
 i n p u t   i n t                                     p e r i o d M A 1                       = 2 0 0 ;           / / P e r i o d   o f   M A 1  
 i n p u t   i n t                                     s h i f t M A 1                         = 0 ;               / / S h i f t 1  
 i n p u t   E N U M _ M A _ M E T H O D               m e t h o d M A 1 = M O D E _ E M A ;                       / / T y p e   d i   s m u s s a m e n t o 1  
 i n p u t   E N U M _ A P P L I E D _ P R I C E       a p p l i e d _ p r i c e M A 1 = P R I C E _ C L O S E ;   / / T y p e   o f   p r i c e 1  
 i n p u t   E N U M _ T I M E F R A M E S             p e r i o d M o v i n g 1 = P E R I O D _ C U R R E N T ;   / / T i m e f r a m e 1  
  
  
 i n p u t   s t r i n g       c o m m e n t _ M A 2   =                 " - - -   M A 2     S E T T I N G   - - - " ;       / /   - - -   M A 2     S E T T I N G   - - -  
 i n p u t   i n t                                     p e r i o d M A 2                       = 2 0 0 ;           / / P e r i o d   o f   M A 2  
 i n p u t   i n t                                     s h i f t M A 2                         = 0 ;               / / S h i f t 2  
 i n p u t   E N U M _ M A _ M E T H O D               m e t h o d M A 2 = M O D E _ E M A ;                       / / T y p e   d i   s m u s s a m e n t o 2  
 i n p u t   E N U M _ A P P L I E D _ P R I C E       a p p l i e d _ p r i c e M A 2 = P R I C E _ C L O S E ;   / / T y p e   o f   p r i c e 2  
 i n p u t   E N U M _ T I M E F R A M E S             p e r i o d M o v i n g 2 = P E R I O D _ C U R R E N T ;   / / T i m e f r a m e 2  
  
 i n p u t   s t r i n g       c o m m e n t _ M A 3   =                 " - - -   M A 3     S E T T I N G   - - - " ;       / /   - - -   M A 3     S E T T I N G   - - -  
 i n p u t   i n t                                     p e r i o d M A 3                       = 2 0 0 ;           / / P e r i o d   o f   M A 3  
 i n p u t   i n t                                     s h i f t M A 3                         = 0 ;               / / S h i f t 3  
 i n p u t   E N U M _ M A _ M E T H O D               m e t h o d M A 3 = M O D E _ E M A ;                       / / T y p e   d i   s m u s s a m e n t o 3  
 i n p u t   E N U M _ A P P L I E D _ P R I C E       a p p l i e d _ p r i c e M A 3 = P R I C E _ C L O S E ;   / / T y p e   o f   p r i c e 3  
 i n p u t   E N U M _ T I M E F R A M E S             p e r i o d M o v i n g 3 = P E R I O D _ C U R R E N T ;   / / T i m e f r a m e 3  
  
 i n p u t   s t r i n g       c o m m e n t _ A T R   =                         " - - -   A T R   S E T T I N G   - - - " ;     / /   - - -   A T R   S E T T I N G   - - -  
 i n p u t   F i l t e r _ A T R _                     F i l t e r _ A T R       =   0 ;                                         / / P e r m e t t e   O r d i n i   c o n   A T R :   F l a t / S o p r a / S o t t o  
 i n p u t   b o o l                                   O n C h a r t _ A T R     =   f a l s e ;                                 / / O n   c h a r t  
 i n p u t   i n t                                     A T R _ p e r i o d = 1 4 ;                                               / / P e r i o d   A T R  
 i n p u t   E N U M _ T I M E F R A M E S             p e r i o d A T R = P E R I O D _ C U R R E N T ;                         / / T i m e f r a m e  
 i n p u t   d o u b l e                               t h e s h o l d A T R     =   1 . 7 5 5 ;                                 / / T h e s h o l d   A T R :   A T R   a b o v e   t h e   t h r e s h o l d   e n a b l e s   t r a d i n g  
  
 i n p u t   s t r i n g       c o m m e n t _ M M                     =   " - - -   M O N E Y   M A N A G E M E N T   - - - " ; / /   - - -   M O N E Y   M A N A G E M E N T   - - -  
 i n p u t   b o o l           E n a b l e A l l o c a z i o n e       =       f a l s e ;                                       / / A b i l i t a / d i s a b i l i t a   l ' a l l o c a z i o n e   d i   c a p i t a l e  
 i n p u t   d o u b l e       c a p i t a l T o A l l o c a t e E A   =     	 	   0 ; 	 	 	 	 	         / /   C a p i t a l e   d a   a l l o c a r e   p e r   l ' E A   ( 0   =   i n t e r o   c a p i t a l e )  
 i n p u t   b o o l           c o m p o u n d i n g                   =         t r u e ;                                       / / C o m p o u n d i n g  
 i n p u t   c a p i t B a s e P e r C o m p o u n d i n g g   c a p i t B a s e P e r C o m p o u n d i n g 1   =   0 ;         / / R e f e r e n c e   c a p i t a l   f o r   C o m p o u n d i n g  
 i n p u t   d o u b l e       l o t s E A                             =           0 . 1 ;                                       / / L o t s  
 i n p u t   d o u b l e       r i s k E A                             =               0 ;                                       / / R i s k   i n   %   [ 0 - 1 0 0 ]  
 i n p u t   d o u b l e       r i s k D e n a r o E A                 =               0 ;                                       / / R i s k   i n   m o n e y  
 i n p u t   d o u b l e       c o m m i s s i o n i                   =               4 ;                                       / / C o m m i s s i o n s   p e r   l o t  
  
 i n p u t   s t r i n g           c o m m e n t _ T T     =                 " - - -   T R A D I N G   T I M E   S E T T I N G S   - - - " ;       / /   - - -   T R A D I N G   T I M E   S E T T I N G S   - - -  
 i n p u t   s t r i n g           c o m m e n t _ T T 1   =                 " - - -   T I M E   S E T T I N G S   1   - - - " ;       / /   - - -   T R A D I N G   T I M E   S E T T I N G S   1   - - -  
 i n p u t   b o o l               F u s o E n a b l e                           =   f a l s e ;         / / T r a d i n g   T i m e  
 i n p u t   F u s o _             F u s o                                       =     2 ;               / / T i m e   Z o n e   S e t t i n g s  
 i n p u t   i n t                 I n p S t a r t H o u r                       =     2 ;               / / S e s s i o n 1   S t a r t   T i m e  
 i n p u t   i n t                 I n p S t a r t M i n u t e                   =     0 ;               / / S e s s i o n 1   S t a r t   M i n u t e  
 i n p u t   i n t                 I n p E n d H o u r                           =   1 5 ;               / / H o u r s 1   E n d   o f   S e s s i o n  
 i n p u t   i n t                 I n p E n d M i n u t e                       =   1 5 ;               / / M i n u t e 1   E n d   o f   S e s s i o n  
 i n p u t   s t r i n g           c o m m e n t _ T T 2   =                 " - - -   T I M E   S E T T I N G S   2   - - - " ;       / /   - - -   T R A D I N G   T I M E   S E T T I N G S   2   - - -  
 i n p u t   i n t                 I n p S t a r t H o u r 1                     =   1 6 ;               / / S e s s i o n 2   S t a r t   T i m e  
 i n p u t   i n t                 I n p S t a r t M i n u t e 1                 =   1 5 ;               / / S e s s i o n 2   S t a r t   M i n u t e  
 i n p u t   i n t                 I n p E n d H o u r 1                         =   2 3 ;               / / H o u r s 2   E n d   o f   S e s s i o n  
 i n p u t   i n t                 I n p E n d M i n u t e 1                     =   0 0 ;               / / M i n u t e 2   E n d   o f   S e s s i o n  
  
 i n p u t   s t r i n g           c o m m e n t _ N E W     =                       " - - -   F I L T E R   N E W S   - - - " ;                           / /   - - -   F I L T E R   N E W S   - - -  
 i n p u t   b o o l               F i l t e r N e w s       =                     f a l s e ;                                                           / / F i l t e r   N e w s  
 i n p u t   E N U M _ C A L E N D A R _ E V E N T _ I M P O R T A N C E         l e v e l I m p a c t =   C A L E N D A R _ I M P O R T A N C E _ L O W   ;  
 i n p u t   S t o p B e f o r e _   S t o p B e f o r e                         =   3 0 ;               / / S t o p   B e f o r e  
 i n p u t   S t o p A f t e r _     S t o p A f t e r                           =   3 0 ;               / / S t o p   A f t e r  
 E N U M _ T I M E F R A M E S       s t a r t i m e _                           =   P E R I O D _ D 1     ;  
 E N U M _ T I M E F R A M E S       e n d t i m e _                             =   P E R I O D _ D 1     ;  
 E N U M _ T I M E F R A M E S       r a n g e t i m e _                         =   P E R I O D _ D 1     ;  
  
  
 d o u b l e   c a p i t a l T o A l l o c a t e               =         0 ;  
 b o o l         a u t o T r a d i n g O n O f f               =   t r u e ;  
  
 d o u b l e   c a p i t a l e B a s e P e r C o m p o u n d i n g   =   A c c o u n t B a l a n c e ( ) ;  
 d o u b l e   d i s t a n z a S L     =   0 ;  
  
 i n t   h a n d l e 1 , h a n d l e 2 , h a n d l e 3 ;  
  
 d o u b l e   i C u s t 1 ;  
 d o u b l e   i C u s t 2 ;  
 d o u b l e   i C u s t 3 ;  
  
 d o u b l e   A S K                   =   0 ;  
 d o u b l e   B I D                   =   0 ;  
  
 s t r i n g   s y m b o l _           =   S y m b o l ( ) ;  
  
 b o o l   s e m C a n d               =   f a l s e ;  
  
 s t r i n g   C o m m e n t o         =   " " ;  
 b o o l   e n a b l e T r a d i n g   =   t r u e ;  
  
 d a t e t i m e   O r a N e w s ;  
  
 i n t   h a n d l e A T R ;  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |   E x p e r t   i n i t i a l i z a t i o n   f u n c t i o n                                                                       |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 i n t   O n I n i t ( )  
     {  
           i f ( T i m e L i c e n s   <   T i m e C u r r e n t ( ) ) { A l e r t ( " E A :   T r i a l   p e r i o d   e x p i r e d !   R e m o v e d   E A   f r o m   t h i s   a c c o u n t ! " ) ;  
             P r i n t ( " E A :   T r i a l   p e r i o d   e x p i r e d !   R e m o v e d   E A   f r o m   t h i s   a c c o u n t ! " ) ;  
             A l e r t ( " E A :   T r i a l   p e r i o d   e x p i r e d !   R e m o v e d   E A   f r o m   t h i s   a c c o u n t ! " ) ;  
             E x p e r t R e m o v e ( ) ; }  
 	 A l l o c a z i o n e _ I n i t ( ) ;      
  
       c o n t r o l l o A c c o u n t s ( T i m e L i c e n s , N u m e r o A c c o u n t 0 , N u m e r o A c c o u n t 1 , N u m e r o A c c o u n t 2 , N u m e r o A c c o u n t 3 , N u m e r o A c c o u n t 4 ,  
                                                                 N u m e r o A c c o u n t 5 , N u m e r o A c c o u n t 6 , N u m e r o A c c o u n t 7 , N u m e r o A c c o u n t 8 , N u m e r o A c c o u n t 9 ) ;  
  
       h a n d l e 1   =   i M A ( s y m b o l _ , p e r i o d M o v i n g 1 , p e r i o d M A 1 , s h i f t M A 1 , m e t h o d M A 1 , a p p l i e d _ p r i c e M A 1 ) ;  
       h a n d l e 2   =   i M A ( s y m b o l _ , p e r i o d M o v i n g 2 , p e r i o d M A 2 , s h i f t M A 2 , m e t h o d M A 2 , a p p l i e d _ p r i c e M A 2 ) ;  
       h a n d l e 3   =   i M A ( s y m b o l _ , p e r i o d M o v i n g 3 , p e r i o d M A 3 , s h i f t M A 3 , m e t h o d M A 3 , a p p l i e d _ p r i c e M A 3 ) ;                
 / / - - -  
       r e t u r n ( I N I T _ S U C C E E D E D ) ;  
     }  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |   E x p e r t   d e i n i t i a l i z a t i o n   f u n c t i o n                                                                   |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 v o i d   O n D e i n i t ( c o n s t   i n t   r e a s o n )  
     {  
 r e s e t I n d i c a t o r s ( ) ;    
 C o m m e n t ( " " ) ;      
        
     }  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |   E x p e r t   t i c k   f u n c t i o n                                                                                           |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 v o i d   O n T i c k ( )  
     {  
 	  
 	 i f ( ! a u t o T r a d i n g O n O f f )   r e t u r n ;  
 	  
 	 A l l o c a z i o n e _ C h e c k ( m a g i c N u m b e r ) ;      
      
 i f ( T i m e L i c e n s   <   T i m e C u r r e n t ( ) ) { A l e r t ( " E A :   T r i a l   p e r i o d   e x p i r e d !   R e m o v e d   E A   f r o m   t h i s   a c c o u n t ! " ) ;  
             P r i n t ( " E A :   T r i a l   p e r i o d   e x p i r e d !   R e m o v e d   E A   f r o m   t h i s   a c c o u n t ! " ) ;  
             A l e r t ( " E A :   T r i a l   p e r i o d   e x p i r e d !   R e m o v e d   E A   f r o m   t h i s   a c c o u n t ! " ) ;  
             E x p e r t R e m o v e ( ) ; }  
 i f ( ! I s M a r k e t T r a d e O p e n ( s y m b o l _ ) | | I s M a r k e t Q u o t e C l o s e d ( s y m b o l _ ) )   r e t u r n ;  
      
      
       A S K = A s k ( s y m b o l _ ) ;  
       B I D = B i d ( s y m b o l _ ) ;  
       C o m m e n t o   =   s p r e a d C o m m e n t ( ) + " \ n " + s w a p l o n g s h o r t C o m m e n t ( ) ;  
       e n a b l e T r a d i n g   =   I s M a r k e t T r a d e O p e n ( s y m b o l _ )   & &   ! I s M a r k e t Q u o t e C l o s e d ( s y m b o l _ ) ;        
       s e m C a n d   =   s e m a f o r o C a n d e l a ( 0 ) ;    
  
       C l o s e O r d e r D o p o N u m C a n d ( C l o s e O r d D o p o N u m C a n d D a l P r i m o O r d i n e _ , m a g i c N u m b e r ) ;  
       g e s t i o n e B r e a k E v e n ( B r e a k E v e n , B e S t a r t P o i n t s , B e S t e p P o i n t s , B e P e r c S t a r t , B e P e r c S t e p , m a g i c N u m b e r , C o m m e n ) ;  
       g e s t i o n e T r a i l S t o p ( T r a i l i n g S t o p , T s S t a r t , T s S t e p , T s P e r c S t a r t , T s P e r c S t e p , T i p o T S C a n d e l e , i n d e x C a n d l e _ , T F C a n d l e , s y m b o l _ , m a g i c N u m b e r , C o m m e n ) ;    
        
       i f ( ! s t r a t N e w C a n d ) E A _ S t r a t e g i a ( m a g i c N u m b e r , s y m b o l _ ) ;  
       i f ( s t r a t N e w C a n d ) { i f ( s e m C a n d ) E A _ S t r a t e g i a ( m a g i c N u m b e r , s y m b o l _ ) ; }  
        
       I n d i c a t o r s ( ) ;  
  
     }  
 / / - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   i M A   ( ) - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 d o u b l e   M o v i n g ( s t r i n g   s y m b o l , E N U M _ T I M E F R A M E S   t i m e f r a m e , i n t   p e r i o d , i n t   m a _ s h i f t , E N U M _ M A _ M E T H O D   m a _ m e t h o d , E N U M _ A P P L I E D _ P R I C E   a p p l i e d _ p r i c e , i n t   i n d e x )  
     { r e t u r n   i M A ( s y m b o l , t i m e f r a m e , p e r i o d , m a _ s h i f t , m a _ m e t h o d , a p p l i e d _ p r i c e , i n d e x ) ; }    
    
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                                     E A _ S t r a t e g i a ( )                                                     |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +      
  
 v o i d   E A _ S t r a t e g i a ( u l o n g   m a g i c , s t r i n g   s y m b o l = N U L L , E N U M _ T I M E F R A M E S   t i m e f r a m e = P E R I O D _ C U R R E N T )  
 {  
       i f ( ! e n a b l e T r a d i n g ) r e t u r n ;  
        
 	 b o o l   	 c a n d e l e I n T r e n d   =   	 p a t t e r n E M A C o n g r u e n t _ T r e n d B u y ( n C a n d l e s , 1 , t i m e f r a m e , s y m b o l , p e r i o d M A 1 , p e r i o d M A 2 , p e r i o d M A 3 )   | |   p a t t e r n E M A C o n g r u e n t _ T r e n d S e l l ( n C a n d l e s , 1 , t i m e f r a m e , s y m b o l , p e r i o d M A 1 , p e r i o d M A 2 , p e r i o d M A 3 ) ;  
 	 i n t   	 n _ C a n d e l e _ T r e n d   =   p a t t e r n E M A C o n g r u e n t _ T r e n d B u y _ n C a n d l e s ( 1 , t i m e f r a m e , s y m b o l , p e r i o d M A 1 , p e r i o d M A 2 , p e r i o d M A 3 )   +   p a t t e r n E M A C o n g r u e n t _ T r e n d S e l l _ n C a n d l e s ( 1 , t i m e f r a m e , s y m b o l , p e r i o d M A 1 , p e r i o d M A 2 , p e r i o d M A 3 ) ;  
 	  
 	 i n t   n u m O r d   =   N u m O r d i n i ( m a g i c N u m b e r , C o m m e n ) ;  
 	 i n t   b a r r e   =   i B a r s ( s y m b o l _ , t i m e f r a m e ) ;  
 	 s t a t i c   i n t   n u m O r d m e m   =   0 ;  
 	 s t a t i c   i n t   b a r r e m e m   =   0 ;  
  
 	 i f ( n u m O r d   ! =   n u m O r d m e m )   { b a r r e m e m   =   b a r r e ; n u m O r d m e m   =   n u m O r d ; }  
  
       d o u b l e   m a f a s t 0   =   M a C u s t o m ( h a n d l e 1 , 0 ) ;  
       d o u b l e   l o w C a n d 0     =   i L o w ( s y m b o l _ , t i m e f r a m e , 0 ) ;  
       d o u b l e   h i g h C a n d 0   =   i H i g h ( s y m b o l _ , t i m e f r a m e , 0 ) ;  
       d o u b l e   o p e n C a n d 0   =   i O p e n ( s y m b o l _ , t i m e f r a m e , 0 ) ;  
        
 / / C o m m e n t o  
 	 s t r i n g   p e n d e n z a s t r i n g   =   " \ n P e n d e n z a   N o n   c o n g r u a   d e l l e   M e d i e " ;  
 	 i f ( p e n d e n z a E n a b l e O r d i n i ( " B u y " ) )     p e n d e n z a s t r i n g   =   " \ n P a t t e r n   P e n d e n z a   d e l l e   M e d i e   M o b i l i :   R i a l z i s t a " ;  
 	 i f ( p e n d e n z a E n a b l e O r d i n i ( " S e l l " ) )   p e n d e n z a s t r i n g   =   " \ n P a t t e r n   P e n d e n z a   d e l l e   M e d i e   M o b i l i :   R i b a s s i s t a " ;  
 	  
 	 C o m m e n t o = C o m m e n t o + " \ n \ n D i s t a n z a   t r a   m e d i e   p e r m e t t e   o r d i n i ?   - - >   " + ( s t r i n g ) d i s t a n z a M i n 3 M A ( ) ;  
 	 C o m m e n t o = C o m m e n t o + " \ n \ n N e l l e   u l t i m e   " + ( s t r i n g ) n C a n d l e s + "   c a n d e l e   v i   �   P a t t e r n   d i   M e d i e   M o b i l i ?   - - >   " + ( s t r i n g ) c a n d e l e I n T r e n d ;  
 	 C o m m e n t o = C o m m e n t o + " \ n N �   c a n d e l e   i n   P a t t e r n   M e d i e   M o b i l i :   " + ( s t r i n g ) n _ C a n d e l e _ T r e n d ;  
 	 i f ( n u m c a n d p e n d e n z e > = 2 ) C o m m e n t o = C o m m e n t o + " \ n N e l l e   u l t i m e   " + ( s t r i n g ) n u m c a n d p e n d e n z e + "   c a n d e l e   v i   �   P a t t e r n   P e n d e n z a   o r d i n i ?   - - >   " + ( s t r i n g ) ( p e n d e n z a E n a b l e O r d i n i ( " B u y " ) | | p e n d e n z a E n a b l e O r d i n i ( " S e l l " ) ) ;  
 	 / / i f ( n u m c a n d p e n d e n z e < 2 ) C o m m e n t o = C o m m e n t o + " \ n P a t t e r n   P e n d e n z a   o r d i n i   N o n   U t i l i z z a t o   d a   I m p o s t a z i o n i " ;  
 	 C o m m e n t o = C o m m e n t o + " \ n N �   c a n d e l e   i n   P a t t e r n   P e n d e n z a :   " + ( s t r i n g ) ( c a n d p a t t p e n d e n z a ( " B u y " ) + c a n d p a t t p e n d e n z a ( " S e l l " ) ) ;  
 	 	  
 	 p e n d e n z e D i s c o r d i ( ) ;  
 	  
 	 b o o l   p a t t e r n B u y 0 ;   b o o l   p a t t e r n S e l l 0 ;    
 	 p a t t e r n B u y 0   =   p a t t e r n S e l l 0   =   ! M a n u a l S t o p N e w s O r d e r s ( )   & &   S p r e a d M a x ( )   & &   G e s t i o n e A T R ( )   & &   d i s t a n z a M i n 3 M A ( ) ;    
 	 p a t t e r n B u y 0   =   p a t t e r n B u y 0   & &   p e n d e n z a E n a b l e O r d i n i ( " B u y " ) ;  
 	  
 	  
 	 / /   B U Y  
 	 b o o l   p a t t e r n B u y 1   =   p a t t e r n E M A C o n g r u e n t _ T r e n d B u y ( n C a n d l e s , 1 , P e r i o d P a t t e r n 1 , s y m b o l , p e r i o d M A 1 , p e r i o d M A 2 , p e r i o d M A 3 ) ;  
 	 b o o l   p a t t e r n B u y 2   =   p a t t e r n E M A C o n g r u e n t _ T r e n d B u y ( n C a n d l e s , 1 , P e r i o d P a t t e r n 2 , s y m b o l , p e r i o d M A 1 , p e r i o d M A 2 , p e r i o d M A 3 ) ;  
 	 b o o l   p a t t e r n B u y 3   =   f a l s e ;  
 	  
 	  
 	 i f ( o l t r e M A _ = = 0     / /   T o c c a   M A  
 	       & &   o p e n C a n d 0   >   m a f a s t 0  
 	       & &   l o w C a n d 0     <   m a f a s t 0  
             & &   l o w C a n d 0     >   v a l o r e S u p e r i o r e ( M a C u s t o m ( h a n d l e 2 , 0 ) , M a C u s t o m ( h a n d l e 3 , 0 ) )  
             & &   b a r r e m e m   ! =   b a r r e  
             )    
             p a t t e r n B u y 3   =   t r u e ;  
 	      
 	 i f ( o l t r e M A _ = = 1   & &   n u m C a n d e l e C o n g r u e C o n S o g l i a I n i z i a l e ( d i r e z C a n d _ , " B u y " , n u m C a n d D i r e z , t i m e F r C a n d )   & &   b a r r e m e m   ! =   b a r r e )   p a t t e r n B u y 3   =   t r u e ;   / / R i e n t r a   M A  
 	  
 	 i f ( p a t t e r n B u y 0   & &   p a t t e r n B u y 1   & &   p a t t e r n B u y 2   & &   p a t t e r n B u y 3   & &   m a x O r d _ B u y S e l l B u y ( n u m M a x O r d i n i , t i p o O r d i n i , m a g i c N u m b e r , C o m m e n ) ) {  
 	       d i s t a n z a S L   =   N o r m a l i z e D o u b l e ( ( A s k ( S y m b o l ( ) ) - S t o p L o s s C h e c k B u y ( ) ) / P o i n t ( ) , D i g i t s ( ) ) ;  
 	 	 S e n d T r a d e B u y I n P o i n t ( s y m b o l _ , m y L o t S i z e ( ) , D e v i a z i o n e , S t o p L o s s C h e c k B u y ( ) , g e s t i o n e T P ( ) , C o m m e n , m a g i c N u m b e r ) ;  
 	 }  
 	  
 	 / /   S E L L  
 	           p a t t e r n S e l l 0 =   p a t t e r n S e l l 0   & &   p e n d e n z a E n a b l e O r d i n i ( " S e l l " ) ;  
 	 b o o l   p a t t e r n S e l l 1   =   p a t t e r n E M A C o n g r u e n t _ T r e n d S e l l ( n C a n d l e s , 1 , P e r i o d P a t t e r n 1 , s y m b o l , p e r i o d M A 1 , p e r i o d M A 2 , p e r i o d M A 3 ) ;  
 	 b o o l   p a t t e r n S e l l 2   =   p a t t e r n E M A C o n g r u e n t _ T r e n d S e l l ( n C a n d l e s , 1 , P e r i o d P a t t e r n 2 , s y m b o l , p e r i o d M A 1 , p e r i o d M A 2 , p e r i o d M A 3 ) ;  
 	 b o o l   p a t t e r n S e l l 3   =   f a l s e ;  
 	  
 	 i f ( o l t r e M A _ = = 0     / /   T o c c a   M A  
             & &   o p e n C a n d 0   <   m a f a s t 0  
 	       & &   h i g h C a n d 0   >   m a f a s t 0  
 	       & &   h i g h C a n d 0   <   v a l o r e I n f e r i o r e ( M a C u s t o m ( h a n d l e 2 , 0 ) , M a C u s t o m ( h a n d l e 3 , 0 ) )  
 	       & &   b a r r e m e m   ! =   b a r r e  
 	       )    
 	       p a t t e r n S e l l 3   =   t r u e ;  
  
 	  
 	 i f ( o l t r e M A _ = = 1   & &   n u m C a n d e l e C o n g r u e C o n S o g l i a I n i z i a l e ( d i r e z C a n d _ , " S e l l " , n u m C a n d D i r e z , t i m e F r C a n d )   & &   b a r r e m e m   ! =   b a r r e )   p a t t e r n S e l l 3   =   t r u e ;   / / R i e n t r a   M A 	  
  
 	 i f ( p a t t e r n S e l l 0   & &   p a t t e r n S e l l 1   & &   p a t t e r n S e l l 2   & &   p a t t e r n S e l l 3   & &   m a x O r d _ B u y S e l l S e l l ( n u m M a x O r d i n i , t i p o O r d i n i , m a g i c N u m b e r , C o m m e n ) ) {  
 	       d i s t a n z a S L   =   N o r m a l i z e D o u b l e ( ( S t o p L o s s C h e c k S e l l ( ) - B i d ( S y m b o l ( ) ) ) / P o i n t ( ) , D i g i t s ( ) ) ;  
 	 	 S e n d T r a d e S e l l I n P o i n t ( s y m b o l _ , m y L o t S i z e ( ) , D e v i a z i o n e , S t o p L o s s C h e c k S e l l ( ) , g e s t i o n e T P ( ) , C o m m e n , m a g i c N u m b e r ) ;  
 	 }  
 	 C o m m e n t   ( C o m m e n t o ) ;  
 }  
  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - + N e l l a   f u n z i o n e   B o d y   e   S h a d o w , l a   c a n d e l a   p i �   a   s x   ( c a n d e l a   d i   v e r s o   i n v e r s o   a l l e   a l t r e   c a n d e l e ) ,    
 / / |                       n u m C a n d e l e C o n g r u e C o n S o g l i a I n i z i a l e ( )                                       |           p e r   s c e l t a ,   h o   e l i m i n a t o   l ' o b b l i g o   a d   e s s e r e   a   c a v a l l o   d e l   v a l o r e   d e l l a   p r i m a   M A   ( M A 1 )  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +      
 b o o l   n u m C a n d e l e C o n g r u e C o n S o g l i a I n i z i a l e ( i n t   T i p o d i r e z C a n d , s t r i n g   B u y S e l l , i n t   n u m C a n d , E N U M _ T I M E F R A M E S   t i m e f r a m e )  
 {  
 b o o l   a   =   f a l s e ;  
 i f ( ! T i p o d i r e z C a n d ) { a = t r u e ; r e t u r n   a ; }  
  
 d o u b l e   c l o s e c a n d 1   =   i C l o s e ( s y m b o l _ , t i m e f r a m e , 1 ) ;  
  
  
 / /   N u m e r o   d i   C a n d e l e   C o n g r u e   c o n   l ' O r d i n e  
 i f ( T i p o d i r e z C a n d = = 1   & &   B u y S e l l = = " B u y " )      
             { a = r i e n t r o M A ( t r u e , B u y S e l l , n u m C a n d , t i m e f r a m e ) ; r e t u r n   a ; }  
              
 i f ( T i p o d i r e z C a n d = = 1   & &   B u y S e l l = = " S e l l " )    
             { a = r i e n t r o M A ( t r u e , B u y S e l l , n u m C a n d , t i m e f r a m e ) ; r e t u r n   a ; }  
        
 / /   N u m e r o   d i   C a n d e l e   C o n g r u e   c o n   l ' O r d i n e   e   s u p e r a m e n t o   B o d y              
 i f ( T i p o d i r e z C a n d = = 2 )  
 {  
 i f ( B u y S e l l = = " B u y "   & &   r i e n t r o M A ( t r u e , B u y S e l l , n u m C a n d , t i m e f r a m e )   & &   c a n d e l a N u m I s B u y O S e l l ( n u m C a n d + 1 , " S e l l " )    
       & &   c l o s e c a n d 1   >   i O p e n ( s y m b o l _ , t i m e f r a m e , n u m C a n d + 1 ) ) { a = t r u e ; r e t u r n   a ; }                                 / /   S u p e r a   B o d y  
        
 i f ( B u y S e l l = = " S e l l "   & &   r i e n t r o M A ( t r u e , B u y S e l l , n u m C a n d , t i m e f r a m e )   & &   c a n d e l a N u m I s B u y O S e l l ( n u m C a n d + 1 , " B u y " )    
       & &   c l o s e c a n d 1   <   i O p e n ( s y m b o l _ , t i m e f r a m e , n u m C a n d + 1 ) ) { a = t r u e ; r e t u r n   a ; }                                 / /   S u p e r a   B o d y  
 }  
  
 / /   N u m e r o   d i   C a n d e l e   C o n g r u e   c o n   l ' O r d i n e   e   s u p e r a m e n t o   S h a d o w  
 i f ( T i p o d i r e z C a n d = = 3 )  
 {  
 i f ( B u y S e l l = = " B u y "   & &   r i e n t r o M A ( t r u e , B u y S e l l , n u m C a n d , t i m e f r a m e )   & &   c a n d e l a N u m I s B u y O S e l l ( n u m C a n d + 1 , " S e l l " )    
       & &   c l o s e c a n d 1   >   i H i g h ( s y m b o l _ , t i m e f r a m e , n u m C a n d + 1 ) ) { a = t r u e ; r e t u r n   a ; }                                 / /   S u p e r a   S h a d o w  
        
 i f ( B u y S e l l = = " S e l l "   & &   r i e n t r o M A ( t r u e , B u y S e l l , n u m C a n d , t i m e f r a m e )   & &   c a n d e l a N u m I s B u y O S e l l ( n u m C a n d + 1 , " B u y " )    
       & &   c l o s e c a n d 1   <   i L o w ( s y m b o l _ , t i m e f r a m e , n u m C a n d + 1 ) ) { a = t r u e ; r e t u r n   a ; }                                   / /   S u p e r a   S h a d o w  
 }  
 r e t u r n   a ;  
 }  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                                 r i e n t r o M A (   )                                                             |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 b o o l   r i e n t r o M A ( b o o l   e n a b l e , s t r i n g   B u y S e l l , i n t   n u m C a n d , E N U M _ T I M E F R A M E S   t i m e f r a m e )  
 {  
 b o o l   a   =   f a l s e ;  
  
  
 f o r ( i n t   i = 1 ; i < = n u m C a n d ; i + + )  
 {  
 i f ( B u y S e l l = = " B u y " )  
 {  
 d o u b l e   c l o s e 1   =   i C l o s e ( s y m b o l _ , t i m e f r a m e , 1 ) ;  
  
 d o u b l e   m a 1   =   M a C u s t o m ( h a n d l e 1 , i ) ;  
 d o u b l e   m a 2   =   M a C u s t o m ( h a n d l e 2 , i ) ;  
 d o u b l e   m a 3   =   M a C u s t o m ( h a n d l e 3 , i ) ;  
  
 d o u b l e   L o w I   =   i L o w ( S y m b o l ( ) , t i m e f r a m e , i ) ;  
 d o u b l e   O p e n I   =   i O p e n ( S y m b o l ( ) , t i m e f r a m e , i ) ;  
 d o u b l e   v a l S u p   =   v a l o r e S u p e r i o r e ( M a C u s t o m ( h a n d l e 2 , i ) , M a C u s t o m ( h a n d l e 3 , i ) ) ;  
  
 s t a t i c   b o o l   t o c c a M A   =   f a l s e ;  
  
 i f ( ! ( m a 1 > m a 2   & &   m a 2 > m a 3 )   | |   L o w I < v a l S u p   | |   ! c a n d e l a N u m I s B u y O S e l l ( i , " B u y " ) )   { t o c c a M A = f a l s e ; a = f a l s e ; r e t u r n   a ; }  
  
 i f ( c a n d e l a N u m I s B u y O S e l l ( i , " B u y " )   & &   d o u b l e C o m p r e s o ( O p e n I , M a C u s t o m ( h a n d l e 1 , i ) , v a l S u p ) )   t o c c a M A = t r u e ;  
  
 i f ( t o c c a M A   & &   i C l o s e ( s y m b o l _ , t i m e f r a m e , 1 ) > M a C u s t o m ( h a n d l e 1 , 1 )   & &   i > = n u m C a n d )   { t o c c a M A = f a l s e ; a = t r u e ; r e t u r n   a ; }  
  
 }  
    
 i f ( B u y S e l l = = " S e l l " )  
 {  
 d o u b l e   c l o s e 1   =   i C l o s e ( s y m b o l _ , t i m e f r a m e , 1 ) ;  
  
 d o u b l e   m a 1   =   M a C u s t o m ( h a n d l e 1 , i ) ;  
 d o u b l e   m a 2   =   M a C u s t o m ( h a n d l e 2 , i ) ;  
 d o u b l e   m a 3   =   M a C u s t o m ( h a n d l e 3 , i ) ;  
  
 d o u b l e   H i g h I   =   i H i g h ( S y m b o l ( ) , t i m e f r a m e , i ) ;  
 d o u b l e   O p e n I   =   i O p e n ( S y m b o l ( ) , t i m e f r a m e , i ) ;  
 d o u b l e   v a l I n f   =   v a l o r e I n f e r i o r e ( M a C u s t o m ( h a n d l e 2 , i ) , M a C u s t o m ( h a n d l e 3 , i ) ) ;  
  
 s t a t i c   b o o l   t o c c a M A   =   f a l s e ;  
  
 i f ( ! ( m a 1 < m a 2   & &   m a 2 < m a 3 )   | |   H i g h I > v a l I n f   | |   ! c a n d e l a N u m I s B u y O S e l l ( i , " S e l l " ) )   { t o c c a M A = f a l s e ; a = f a l s e ; r e t u r n   a ; }  
  
 i f ( c a n d e l a N u m I s B u y O S e l l ( i , " S e l l " )   & &   d o u b l e C o m p r e s o ( O p e n I , M a C u s t o m ( h a n d l e 1 , i ) , v a l I n f ) )   t o c c a M A = t r u e ;  
  
 i f ( t o c c a M A   & &   i C l o s e ( s y m b o l _ , t i m e f r a m e , 1 ) < M a C u s t o m ( h a n d l e 1 , 1 )   & &   i > = n u m C a n d )   { t o c c a M A = f a l s e ; a = t r u e ; r e t u r n   a ; }  
 } }  
 r e t u r n   a ;  
 }  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                     c a n d p a t t p e n d e n z a ( s t r i n g   B u y S e l l )                                 |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 i n t   c a n d p a t t p e n d e n z a ( s t r i n g   B u y S e l l )  
 {  
 i n t   a   =   1 ;  
  
 i f ( B u y S e l l = = " B u y " )  
 {  
 f o r ( i n t   i = 1 ; i < = i B a r s ( S y m b o l ( s y m b o l _ ) , P E R I O D _ C U R R E N T ) ; i + + )  
 {  
 i f ( M a C u s t o m ( h a n d l e 1 , i ) > M a C u s t o m ( h a n d l e 1 , i + 1 )   & &   M a C u s t o m ( h a n d l e 2 , i ) > M a C u s t o m ( h a n d l e 2 , i + 1 )   & &   M a C u s t o m ( h a n d l e 3 , i ) > M a C u s t o m ( h a n d l e 3 , i + 1 ) )  
 { a + + ; }  
 i f ( M a C u s t o m ( h a n d l e 1 , i ) < M a C u s t o m ( h a n d l e 1 , i + 1 )   | |   M a C u s t o m ( h a n d l e 2 , i ) < M a C u s t o m ( h a n d l e 2 , i + 1 )   | |   M a C u s t o m ( h a n d l e 3 , i ) < M a C u s t o m ( h a n d l e 3 , i + 1 ) )  
 { r e t u r n   a - 1 ; }  
 }  
 }  
  
 i f ( B u y S e l l = = " S e l l " ) {  
 f o r ( i n t   i = 1 ; i < = i B a r s ( S y m b o l ( s y m b o l _ ) , P E R I O D _ C U R R E N T ) ; i + + )  
 {  
 i f ( M a C u s t o m ( h a n d l e 1 , i ) < M a C u s t o m ( h a n d l e 1 , i + 1 )   & &   M a C u s t o m ( h a n d l e 2 , i ) < M a C u s t o m ( h a n d l e 2 , i + 1 )   & &   M a C u s t o m ( h a n d l e 3 , i ) < M a C u s t o m ( h a n d l e 3 , i + 1 ) )  
 { a + + ; }  
 i f ( M a C u s t o m ( h a n d l e 1 , i ) > M a C u s t o m ( h a n d l e 1 , i + 1 )   | |   M a C u s t o m ( h a n d l e 2 , i ) > M a C u s t o m ( h a n d l e 2 , i + 1 )   | |   M a C u s t o m ( h a n d l e 3 , i ) > M a C u s t o m ( h a n d l e 3 , i + 1 ) )  
 { r e t u r n   a - 1 ; }  
 }  
 }  
 r e t u r n   a ;  
 }  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                         p e n d e n z a A p e r t u r a O r d i n i ( s t r i n g   B u y S e l l )                                 |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 b o o l   p e n d e n z a E n a b l e O r d i n i ( s t r i n g   B u y S e l l )  
 {  
 b o o l   a   =   t r u e ;  
 i f ( n u m c a n d p e n d e n z e < 2 ) r e t u r n   a ;  
  
 i f ( B u y S e l l = = " B u y " )  
 {  
 f o r ( i n t   i = 1 ; i < = n u m c a n d p e n d e n z e ; i + + )  
 {  
 i f ( M a C u s t o m ( h a n d l e 1 , i ) < M a C u s t o m ( h a n d l e 1 , i + 1 )   | |   M a C u s t o m ( h a n d l e 2 , i ) < M a C u s t o m ( h a n d l e 2 , i + 1 )   | |   M a C u s t o m ( h a n d l e 3 , i ) < M a C u s t o m ( h a n d l e 3 , i + 1 ) )  
 { a = f a l s e ; r e t u r n   a ; }  
 }  
 }  
  
 i f ( B u y S e l l = = " S e l l " ) {  
 f o r ( i n t   i = 1 ; i < = n u m c a n d p e n d e n z e ; i + + )  
 {  
 i f ( M a C u s t o m ( h a n d l e 1 , i ) > M a C u s t o m ( h a n d l e 1 , i + 1 )   | |   M a C u s t o m ( h a n d l e 2 , i ) > M a C u s t o m ( h a n d l e 2 , i + 1 )   | |   M a C u s t o m ( h a n d l e 3 , i ) > M a C u s t o m ( h a n d l e 3 , i + 1 ) )  
 { a = f a l s e ; r e t u r n   a ; }  
 }  
 }  
 r e t u r n   a ;  
 }  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                         p e n d e n z a ( s t r i n g   B u y S e l l )                                             |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 b o o l   p e n d e n z a ( s t r i n g   B u y S e l l )  
 {  
 b o o l   a   =   f a l s e ;  
  
 s t a t i c   i n t   c o n t p e n d   =   0 ;  
 i f ( n u m c a n d c h i u d i o r d < 2   & &   ! c o n t p e n d ) { c o n t p e n d + + ; A l e r t ( " I m p o s t a z i o n e   N u m e r o   C a n d e l e   p e r   d e t e r m i n a r e   l a   P e n d e n z a   E R R A T A !   M i n i m o   2 . " ) ; r e t u r n   f a l s e ; }  
 i f ( B u y S e l l = = " B u y " )  
 {  
 i f ( M a C u s t o m ( h a n d l e 1 , 1 )   >   M a C u s t o m ( h a n d l e 1 , n u m c a n d c h i u d i o r d )   & &   M a C u s t o m ( h a n d l e 2 , 1 )   >   M a C u s t o m ( h a n d l e 2 , n u m c a n d c h i u d i o r d )   & &   M a C u s t o m ( h a n d l e 3 , 1 )   >   M a C u s t o m ( h a n d l e 3 , n u m c a n d c h i u d i o r d ) )  
       { a = t r u e ; / / S t r i n g A d d ( C o m m e n t o , " \ n M e d i e   M o b i l i   R i a l z i s t e " ) ;  
       }  
 }  
  
 i f ( B u y S e l l = = " S e l l " )  
 {  
 i f ( M a C u s t o m ( h a n d l e 1 , 1 )   <   M a C u s t o m ( h a n d l e 1 , n u m c a n d c h i u d i o r d )   & &   M a C u s t o m ( h a n d l e 2 , 1 )   <   M a C u s t o m ( h a n d l e 2 , n u m c a n d c h i u d i o r d )   & &   M a C u s t o m ( h a n d l e 3 , 1 )   <   M a C u s t o m ( h a n d l e 3 , n u m c a n d c h i u d i o r d ) )  
 { a = t r u e ; / / S t r i n g A d d ( C o m m e n t o , " \ n M e d i e   M o b i l i   R i b a s s i s t e " ) ;  
 }  
 }  
 r e t u r n   a ;  
 }  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                               p e n d e n z e D i s c o r d i ( )                                                   |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 v o i d   p e n d e n z e D i s c o r d i ( )      
 {  
 i f ( p e n d e n z a C h i u d e O r d i n i _ = = 2   & &   N u m O r d i n i ( m a g i c N u m b e r , C o m m e n ) > 0   & &   ! p e n d e n z a ( " B u y " )   & &   ! p e n d e n z a ( " S e l l " ) )   b r u t a l C l o s e T o t a l ( s y m b o l _ , m a g i c N u m b e r ) ;  
 i f ( p e n d e n z a C h i u d e O r d i n i _ = = 3   & &   N u m O r d i n i ( m a g i c N u m b e r , C o m m e n ) > 0   & &   ! p e n d e n z a ( " B u y " )   & &   ! p e n d e n z a ( " S e l l " ) )   b r u t a l C l o s e A l l P r o f i t a b l e P o s i t i o n s ( s y m b o l _ , m a g i c N u m b e r ) ;  
 i f ( p e n d e n z a C h i u d e O r d i n i _ = = 4   & &   N u m O r d B u y   ( m a g i c N u m b e r , C o m m e n ) > 0   & &   p e n d e n z a ( " S e l l " ) )   { b r u t a l C l o s e B u y P o s i t i o n s ( s y m b o l _ , m a g i c N u m b e r ) ; }  
 i f ( p e n d e n z a C h i u d e O r d i n i _ = = 4   & &   N u m O r d S e l l ( m a g i c N u m b e r , C o m m e n ) > 0   & &   p e n d e n z a ( " B u y " ) )   { b r u t a l C l o s e S e l l P o s i t i o n s ( s y m b o l _ , m a g i c N u m b e r ) ; }  
 }  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                                   d i s t a n z a M i n 3 M A ( )                                                   |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 b o o l   d i s t a n z a M i n 3 M A ( )  
 {  
 b o o l   a   =   t r u e ;  
 d o u b l e   m a 1   =   p e r i o d M A 1   >   0   ?   M a C u s t o m ( h a n d l e 1 , 0 )   :   0 ;          
 d o u b l e   m a 2   =   p e r i o d M A 2   >   0   ?   M a C u s t o m ( h a n d l e 2 , 0 )   :   0 ;  
 d o u b l e   m a 3   =   p e r i o d M A 3   >   0   ?   M a C u s t o m ( h a n d l e 3 , 0 )   :   0 ;  
 i f ( ( V a l o r e S u p e r i o r e ( m a 1 , m a 2 , m a 3 ) - V a l o r e I n f e r i o r e ( m a 1 , m a 2 , m a 3 ) ) / P o i n t ( ) < d i s t a n z a M i n 3 M A ) a = f a l s e ;  
 r e t u r n   a ;  
 }  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                             p a t t e r n E M A C o n g r u e n t                                                   |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 b o o l   p a t t e r n E M A C o n g r u e n t ( s t r i n g   t y p e , i n t   i n d e x = 0 , E N U M _ T I M E F R A M E S   t i m e f r a m e = P E R I O D _ C U R R E N T , s t r i n g   s y m b o l = N U L L , i n t   p e r i o d E M A _ 1 = 0 , i n t   p e r i o d E M A _ 2 = 0 , i n t   p e r i o d E M A _ 3 = 0 , i n t   p e r i o d E M A _ 4 = 0 , i n t   p e r i o d E M A _ 5 = 0 , i n t   p e r i o d E M A _ 6 = 0 ) {  
  
  
       d o u b l e   e m a 1   =   p e r i o d E M A _ 1   >   0   ?   M a C u s t o m ( h a n d l e 1 , i n d e x )   :   0 ;    
       d o u b l e   e m a 2   =   p e r i o d E M A _ 2   >   0   ?   M a C u s t o m ( h a n d l e 2 , i n d e x )   :   0 ;  
       d o u b l e   e m a 3   =   p e r i o d E M A _ 3   >   0   ?   M a C u s t o m ( h a n d l e 3 , i n d e x )   :   0 ;  
       d o u b l e   e m a 4   =   p e r i o d E M A _ 4   >   0   ?   e m a ( p e r i o d E M A _ 4 , i n d e x , t i m e f r a m e , s y m b o l )   :   0 ;  
       d o u b l e   e m a 5   =   p e r i o d E M A _ 5   >   0   ?   e m a ( p e r i o d E M A _ 5 , i n d e x , t i m e f r a m e , s y m b o l )   :   0 ;  
       d o u b l e   e m a 6   =   p e r i o d E M A _ 6   >   0   ?   e m a ( p e r i o d E M A _ 6 , i n d e x , t i m e f r a m e , s y m b o l )   :   0 ;  
        
       i f ( e m a 1   >   0   & &   e m a 2   >   0 ) {  
             i f ( t y p e   = =   " O P _ B U Y " ) {  
                   i f ( e m a 3   = =   0 )   r e t u r n   e m a 1   >   e m a 2 ;  
                   i f ( e m a 4   = =   0 )   r e t u r n   e m a 1   >   e m a 2   & &   e m a 2   >   e m a 3 ;  
                   i f ( e m a 5   = =   0 )   r e t u r n   e m a 1   >   e m a 2   & &   e m a 2   >   e m a 3   & &   e m a 3   >   e m a 4 ;  
                   i f ( e m a 6   = =   0 )   r e t u r n   e m a 1   >   e m a 2   & &   e m a 2   >   e m a 3   & &   e m a 3   >   e m a 4   & &   e m a 4   >   e m a 5 ;  
                   r e t u r n   e m a 1   >   e m a 2   & &   e m a 2   >   e m a 3   & &   e m a 3   >   e m a 4   & &   e m a 4   >   e m a 5   & &   e m a 5   >   e m a 6 ;  
             }  
             i f ( t y p e   = =   " O P _ S E L L " ) {  
                   i f ( e m a 3   = =   0 )   r e t u r n   e m a 1   <   e m a 2 ;  
                   i f ( e m a 4   = =   0 )   r e t u r n   e m a 1   <   e m a 2   & &   e m a 2   <   e m a 3 ;  
                   i f ( e m a 5   = =   0 )   r e t u r n   e m a 1   <   e m a 2   & &   e m a 2   <   e m a 3   & &   e m a 3   <   e m a 4 ;  
                   i f ( e m a 6   = =   0 )   r e t u r n   e m a 1   <   e m a 2   & &   e m a 2   <   e m a 3   & &   e m a 3   <   e m a 4   & &   e m a 4   <   e m a 5 ;  
                   r e t u r n   e m a 1   <   e m a 2   & &   e m a 2   <   e m a 3   & &   e m a 3   <   e m a 4   & &   e m a 4   <   e m a 5   & &   e m a 5   <   e m a 6 ;  
             }  
       }  
       r e t u r n   f a l s e ;  
 }  
  
 b o o l   p a t t e r n E M A C o n g r u e n t _ B u y   ( i n t   i n d e x = 0 , E N U M _ T I M E F R A M E S   t i m e f r a m e = P E R I O D _ C U R R E N T , s t r i n g   s y m b o l = N U L L , i n t   p e r i o d E M A _ 1 = 0 , i n t   p e r i o d E M A _ 2 = 0 , i n t   p e r i o d E M A _ 3 = 0 , i n t   p e r i o d E M A _ 4 = 0 , i n t   p e r i o d E M A _ 5 = 0 , i n t   p e r i o d E M A _ 6 = 0 ) {  
 	 r e t u r n   p a t t e r n E M A C o n g r u e n t ( " O P _ B U Y " , i n d e x , t i m e f r a m e , s y m b o l , p e r i o d E M A _ 1 , p e r i o d E M A _ 2 , p e r i o d E M A _ 3 , p e r i o d E M A _ 4 , p e r i o d E M A _ 5 , p e r i o d E M A _ 6 ) ;  
 }  
 b o o l   p a t t e r n E M A C o n g r u e n t _ S e l l ( i n t   i n d e x = 0 , E N U M _ T I M E F R A M E S   t i m e f r a m e = P E R I O D _ C U R R E N T , s t r i n g   s y m b o l = N U L L , i n t   p e r i o d E M A _ 1 = 0 , i n t   p e r i o d E M A _ 2 = 0 , i n t   p e r i o d E M A _ 3 = 0 , i n t   p e r i o d E M A _ 4 = 0 , i n t   p e r i o d E M A _ 5 = 0 , i n t   p e r i o d E M A _ 6 = 0 ) {  
 	 r e t u r n   p a t t e r n E M A C o n g r u e n t ( " O P _ S E L L " , i n d e x , t i m e f r a m e , s y m b o l , p e r i o d E M A _ 1 , p e r i o d E M A _ 2 , p e r i o d E M A _ 3 , p e r i o d E M A _ 4 , p e r i o d E M A _ 5 , p e r i o d E M A _ 6 ) ;  
 }  
  
 b o o l   p a t t e r n E M A C o n g r u e n t _ T r e n d B u y ( i n t   n C a n d l e s T o A n a l y z e , i n t   i n d e x S t a r t = 0 , E N U M _ T I M E F R A M E S   t i m e f r a m e = P E R I O D _ C U R R E N T , s t r i n g   s y m b o l = N U L L , i n t   p e r i o d E M A _ 1 = 0 , i n t   p e r i o d E M A _ 2 = 0 , i n t   p e r i o d E M A _ 3 = 0 , i n t   p e r i o d E M A _ 4 = 0 , i n t   p e r i o d E M A _ 5 = 0 , i n t   p e r i o d E M A _ 6 = 0 ) {  
       f o r ( i n t   i = 0 ; i < n C a n d l e s T o A n a l y z e ; i + + ) 	 i f ( ! p a t t e r n E M A C o n g r u e n t _ B u y ( i n d e x S t a r t + i , t i m e f r a m e , s y m b o l , p e r i o d E M A _ 1 , p e r i o d E M A _ 2 , p e r i o d E M A _ 3 , p e r i o d E M A _ 4 , p e r i o d E M A _ 5 , p e r i o d E M A _ 6 ) )   r e t u r n   f a l s e ;  
       r e t u r n   t r u e ;  
 }  
  
 b o o l   p a t t e r n E M A C o n g r u e n t _ T r e n d S e l l ( i n t   n C a n d l e s T o A n a l y z e , i n t   i n d e x S t a r t = 0 , E N U M _ T I M E F R A M E S   t i m e f r a m e = P E R I O D _ C U R R E N T , s t r i n g   s y m b o l = N U L L , i n t   p e r i o d E M A _ 1 = 0 , i n t   p e r i o d E M A _ 2 = 0 , i n t   p e r i o d E M A _ 3 = 0 , i n t   p e r i o d E M A _ 4 = 0 , i n t   p e r i o d E M A _ 5 = 0 , i n t   p e r i o d E M A _ 6 = 0 ) {  
       f o r ( i n t   i = 0 ; i < n C a n d l e s T o A n a l y z e ; i + + ) 	 i f ( ! p a t t e r n E M A C o n g r u e n t _ S e l l ( i n d e x S t a r t + i , t i m e f r a m e , s y m b o l , p e r i o d E M A _ 1 , p e r i o d E M A _ 2 , p e r i o d E M A _ 3 , p e r i o d E M A _ 4 , p e r i o d E M A _ 5 , p e r i o d E M A _ 6 ) )   r e t u r n   f a l s e ;  
       r e t u r n   t r u e ;  
 }  
  
 i n t   p a t t e r n E M A C o n g r u e n t _ T r e n d B u y _ n C a n d l e s ( i n t   i n d e x S t a r t = 0 , E N U M _ T I M E F R A M E S   t i m e f r a m e = P E R I O D _ C U R R E N T , s t r i n g   s y m b o l = N U L L , i n t   p e r i o d E M A _ 1 = 0 , i n t   p e r i o d E M A _ 2 = 0 , i n t   p e r i o d E M A _ 3 = 0 , i n t   p e r i o d E M A _ 4 = 0 , i n t   p e r i o d E M A _ 5 = 0 , i n t   p e r i o d E M A _ 6 = 0 ) {  
 	 i n t   n C o u n t   =   0 ;  
 	 f o r ( i n t   i = i n d e x S t a r t ; i < i B a r s ( S y m b o l ( s y m b o l ) , t i m e f r a m e ) - 1 ; i + + ) 	 i f ( p a t t e r n E M A C o n g r u e n t _ B u y ( i , t i m e f r a m e , s y m b o l , p e r i o d E M A _ 1 , p e r i o d E M A _ 2 , p e r i o d E M A _ 3 , p e r i o d E M A _ 4 , p e r i o d E M A _ 5 , p e r i o d E M A _ 6 ) )   n C o u n t + + ;   e l s e   b r e a k ;  
       r e t u r n   n C o u n t ;  
 }  
  
 i n t   p a t t e r n E M A C o n g r u e n t _ T r e n d S e l l _ n C a n d l e s ( i n t   i n d e x S t a r t = 0 , E N U M _ T I M E F R A M E S   t i m e f r a m e = P E R I O D _ C U R R E N T , s t r i n g   s y m b o l = N U L L , i n t   p e r i o d E M A _ 1 = 0 , i n t   p e r i o d E M A _ 2 = 0 , i n t   p e r i o d E M A _ 3 = 0 , i n t   p e r i o d E M A _ 4 = 0 , i n t   p e r i o d E M A _ 5 = 0 , i n t   p e r i o d E M A _ 6 = 0 ) {  
 	 i n t   n C o u n t   =   0 ;  
 	 f o r ( i n t   i = i n d e x S t a r t ; i < i B a r s ( S y m b o l ( s y m b o l ) , t i m e f r a m e ) - 1 ; i + + ) 	 i f ( p a t t e r n E M A C o n g r u e n t _ S e l l ( i , t i m e f r a m e , s y m b o l , p e r i o d E M A _ 1 , p e r i o d E M A _ 2 , p e r i o d E M A _ 3 , p e r i o d E M A _ 4 , p e r i o d E M A _ 5 , p e r i o d E M A _ 6 ) )   n C o u n t + + ;   e l s e   b r e a k ;  
       r e t u r n   n C o u n t ;  
 }    
  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                                         G e s t i o n e A T R ( )                                                   |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 b o o l   G e s t i o n e A T R ( )  
     {  
       b o o l   a = t r u e ;  
       i f ( ! F i l t e r _ A T R )   r e t u r n   a ;  
       i f ( F i l t e r _ A T R = = 1   & &   i A T R ( S y m b o l ( ) , p e r i o d A T R , A T R _ p e r i o d , 0 )   <   t h e s h o l d A T R )   a = f a l s e ;  
       i f ( F i l t e r _ A T R = = 2   & &   i A T R ( S y m b o l ( ) , p e r i o d A T R , A T R _ p e r i o d , 0 )   >   t h e s h o l d A T R )   a = f a l s e ;        
       r e t u r n   a ;  
     }  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                                   m y L o t S i z e ( )                                                             |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 d o u b l e   m y L o t S i z e ( )  
     {  
       r e t u r n   m y L o t S i z e ( c o m p o u n d i n g , A c c o u n t E q u i t y ( ) , c a p i t a l e B a s e P e r C o m p o u n d i n g , l o t s E A , r i s k E A , r i s k D e n a r o E A , ( i n t ) d i s t a n z a S L , c o m m i s s i o n i ) ;  
     }      
      
      
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                                                                                                                     |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
  
 d o u b l e   m y V o l u m e ( u l o n g   m a g i c , s t r i n g   s y m b o l = N U L L ) {  
 	 d o u b l e   l o t s   =   l o t s E A * c o m p E A ( m a g i c , s y m b o l ) ;  
 	  
 	 l o t s   =   N o r m a l i z e D o u b l e ( l o t s , 2 ) ;  
 	  
 	 r e t u r n   l o t s ;  
 }  
      
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |   F U N Z I O N I   A U S I L I A R I E                                                                                             |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 b o o l   s e m a f o r o S e c o n d i ( u s h o r t   i d C o n t a t o r e , i n t   s e c o n d i P e r S e m a f o r o = 1 0 ) {  
       s t a t i c   d a t e t i m e   c o n t a t o r e S e c o n d i [ U S H O R T _ M A X ]   =   { 0 } ;  
       i f ( T i m e C u r r e n t ( )   > =   c o n t a t o r e S e c o n d i [ i d C o n t a t o r e ] + s e c o n d i P e r S e m a f o r o ) {  
             r e t u r n   ( c o n t a t o r e S e c o n d i [ i d C o n t a t o r e ]   =   T i m e C u r r e n t ( ) )   > =   0 ;  
       }  
       r e t u r n   f a l s e ;  
 }  
  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |   A L L O C A Z I O N E   C A P I T A L E                                                                                           |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
  
 v o i d   A l l o c a z i o n e _ I n i t ( ) {  
  
 	 c a p i t a l T o A l l o c a t e   =   	 c a p i t a l T o A l l o c a t e E A   >   0   ?   c a p i t a l T o A l l o c a t e E A   :   A c c o u n t B a l a n c e ( ) ;  
 }  
  
  
 / /   C o n t r o l l o   A l l o c a z i o n e   C a p i t a l e  
 v o i d   A l l o c a z i o n e _ C h e c k ( u l o n g   m a g i c , s t r i n g   s y m b o l = N U L L ) {  
 	  
 	 i f ( ! s e m a f o r o S e c o n d i ( 0 , 2 ) )   r e t u r n ;  
 	  
 	 i f ( E q u i t y E A ( m a g i c , s y m b o l )   < =   0 ) { i f ( ! E n a b l e A l l o c a z i o n e ) r e t u r n ;  
       	 P r i n t ( " R a g g i u n t a   s o g l i a   m a s s i m a   p e r   A l l o c a z i o n e   C a p i t a l e   ( " + c u r r e n c y S y m b o l A c c o u n t ( ) + D o u b l e S t r i n g ( c a p i t a l T o A l l o c a t e ) + " ) ,   C h i u s u r a   t o t a l e   o r d i n i ! " ) ;  
       	 b r u t a l C l o s e T o t a l ( s y m b o l , m a g i c ) ;  
       	 a u t o T r a d i n g O n O f f   =   f a l s e ;  
 	 }  
 }  
  
 d o u b l e   E q u i t y E A ( u l o n g   m a g i c , s t r i n g   s y m b o l = N U L L ) {  
 	 r e t u r n   c a p i t a l T o A l l o c a t e   +   p r o f i t t i E A ( m a g i c , s y m b o l ) ;  
 }  
  
 d o u b l e   c o m p E A ( u l o n g   m a g i c , s t r i n g   s y m b o l = N U L L ) {  
 	 i f ( c o m p o u n d i n g   & &   c a p i t a l T o A l l o c a t e   >   0 )   r e t u r n   ( E q u i t y E A ( m a g i c , s y m b o l ) ) / c a p i t a l T o A l l o c a t e ;  
 	 r e t u r n   1 ;  
 }  
  
  
 d o u b l e   p r o f i t t i E A ( u l o n g   m a g i c , s t r i n g   s y m b o l = N U L L ) {  
 	 s t a t i c   d o u b l e   p r o f i t H i s t o r y   =   0 ;  
 	 d o u b l e   p r o f i t F l o a t i n g   =   0 ;  
 	  
 	 s t a t i c   i n t   i   =   0 ;  
 	  
 	 # i f d e f   _ _ M Q L 5 _ _  
 	 H i s t o r y S e l e c t ( 0 , D ' 3 0 0 0 . 0 1 . 0 1 ' ) ;  
 	 f o r ( ; i < H i s t o r y D e a l s T o t a l ( ) ; i + + ) {  
             i f ( H i s t o r y D e a l S e l e c t B y P o s ( i )   & &   H i s t o r y D e a l I s S y m b o l ( s y m b o l )   & &   H i s t o r y D e a l I s M a g i c N u m b e r ( m a g i c ) ) {  
                   p r o f i t H i s t o r y   + =   H i s t o r y D e a l P r o f i t F u l l ( ) ;  
             }  
       }  
        
       f o r ( i n t   j = 0 ; j < P o s i t i o n s T o t a l ( ) ; j + + ) {  
             i f ( P o s i t i o n S e l e c t B y P o s ( j )   & &   P o s i t i o n I s S y m b o l ( s y m b o l )   & &   P o s i t i o n I s M a g i c N u m b e r ( m a g i c ) ) {  
                   p r o f i t F l o a t i n g   + =   P o s i t i o n P r o f i t F u l l ( ) ;  
             }  
       }  
       # e n d i f    
        
       # i f d e f   _ _ M Q L 4 _ _  
       f o r ( ; i < O r d e r s H i s t o r y T o t a l ( ) ; i + + ) {  
       	 i f ( O r d e r S e l e c t B y P o s ( i , M O D E _ H I S T O R Y )   & &   O r d e r I s S y m b o l ( s y m b o l )   & &   O r d e r I s M a g i c N u m b e r ( m a g i c ) ) {  
                   p r o f i t H i s t o r y   + =   O r d e r P r o f i t F u l l ( ) ;  
             }  
 	 }  
 	  
 	 f o r ( i n t   j = 0 ; j < O r d e r s T o t a l ( ) ; j + + ) {  
             i f ( O r d e r S e l e c t B y P o s ( j )   & &   O r d e r I s S y m b o l ( s y m b o l )   & &   O r d e r I s M a g i c N u m b e r ( m a g i c ) ) {  
                   p r o f i t F l o a t i n g   + =   O r d e r P r o f i t F u l l ( ) ;  
             }  
       }  
       # e n d i f    
        
        
       r e t u r n   p r o f i t H i s t o r y   +   p r o f i t F l o a t i n g ;  
 }    
  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                                         S p r e a d M a x                                                           |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 b o o l   S p r e a d M a x ( )  
     {  
       b o o l   a = f a l s e ;  
       i f ( M a x S p r e a d = = 0   | |   ( ( S p r e a d ( S y m b o l ( ) )   <   M a x S p r e a d )   & &   M a x S p r e a d ! = 0 ) )  
           {  
             a = t r u e ;  
           }  
       r e t u r n   a ;  
     }  
      
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                           M a n u a l S t o p N e w s O r d e r s                                                   |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 b o o l   M a n u a l S t o p N e w s O r d e r s ( )  
     {  
       b o o l   a = f a l s e ;  
       s t a t i c   c h a r   x x x = 0 ;  
       i f ( ! S t o p N e w s O r d e r s )  
           {  
             x x x = 0 ;  
             a   =   f a l s e ;  
             r e t u r n   a ;  
           }  
       i f ( S t o p N e w s O r d e r s & & N u m P o s i z i o n i ( m a g i c N u m b e r ) = = 0 & & x x x = = 0 )  
           {  
             P r i n t ( " A u t o   S t o p   N e w s   O r d e r s   E A   " , S y m b o l ( ) ) ;  
             C o m m e n t ( " A u t o   S t o p   N e w s   O r d e r s   E A   " , S y m b o l ( ) ) ;  
             A l e r t ( " A u t o   S t o p   N e w s   O r d e r s   E A   " , S y m b o l ( ) ) ;  
             x x x + + ;  
           }  
       i f ( S t o p N e w s O r d e r s & & N u m P o s i z i o n i ( m a g i c N u m b e r ) = = 0 )  
             a   =   t r u e ;  
       r e t u r n   a ;  
     }    
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                               c o n t r o l A c c o u n t s                                                         |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 b o o l   c o n t r o l A c c o u n t s ( )  
     {  
       i f ( ! I s C o n n e c t e d ( ) )  
           {  
             P r i n t ( " N o   c o n n e c t i o n " ) ;  
             r e t u r n   t r u e ;  
           }  
       b o o l   a   =   f a l s e ;  
       i f ( A c c o u n t N u m b e r ( )   = =   N u m e r o A c c o u n t 0   & &   T i m e L i c e n s   >   T i m e C u r r e n t ( ) )   a   =   t r u e ;  
       i f ( A c c o u n t N u m b e r ( )   = =   N u m e r o A c c o u n t 1   & &   T i m e L i c e n s   >   T i m e C u r r e n t ( ) )   a   =   t r u e ;  
       i f ( A c c o u n t N u m b e r ( )   = =   N u m e r o A c c o u n t 2   & &   T i m e L i c e n s   >   T i m e C u r r e n t ( ) )   a   =   t r u e ;  
       i f ( A c c o u n t N u m b e r ( )   = =   N u m e r o A c c o u n t 3   & &   T i m e L i c e n s   >   T i m e C u r r e n t ( ) )   a   =   t r u e ;  
       i f ( A c c o u n t N u m b e r ( )   = =   N u m e r o A c c o u n t 4   & &   T i m e L i c e n s   >   T i m e C u r r e n t ( ) )   a   =   t r u e ;  
       i f ( A c c o u n t N u m b e r ( )   = =   N u m e r o A c c o u n t 5   & &   T i m e L i c e n s   >   T i m e C u r r e n t ( ) )   a   =   t r u e ;  
       i f ( A c c o u n t N u m b e r ( )   = =   N u m e r o A c c o u n t 6   & &   T i m e L i c e n s   >   T i m e C u r r e n t ( ) )   a   =   t r u e ;  
       i f ( A c c o u n t N u m b e r ( )   = =   N u m e r o A c c o u n t 7   & &   T i m e L i c e n s   >   T i m e C u r r e n t ( ) )   a   =   t r u e ;  
       i f ( A c c o u n t N u m b e r ( )   = =   N u m e r o A c c o u n t 8   & &   T i m e L i c e n s   >   T i m e C u r r e n t ( ) )   a   =   t r u e ;  
       i f ( A c c o u n t N u m b e r ( )   = =   N u m e r o A c c o u n t 9   & &   T i m e L i c e n s   >   T i m e C u r r e n t ( ) )   a   =   t r u e ;              
       i f ( a   = =   t r u e )   P r i n t ( " E A :   A c c o u n t   O k ! " ) ;  
       e l s e  
           { ( P r i n t ( " E A :   t r i a l   l i c e n s e   e x p i r e d   o r   A c c o u n t   w i t h o u t   p e r m i s s i o n " ) ) ;   E x p e r t R e m o v e ( ) ; }  
       r e t u r n   a ;  
     }  
 / / - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -      
 d o u b l e   M a C u s t o m ( i n t   h a n d l e , i n t   i n d e x )  
 {  
       i f ( h a n d l e   >   I N V A L I D _ H A N D L E ) {  
 	       d o u b l e   v a l _ I n d i c a t o r [ ] ;  
 	 	 i f ( C o p y B u f f e r ( h a n d l e , 0 , i n d e x , 1 , v a l _ I n d i c a t o r )   >   0 ) {  
 	 	 	 i f ( A r r a y S i z e ( v a l _ I n d i c a t o r )   >   0 ) {  
 	 	 	 	 r e t u r n   v a l _ I n d i c a t o r [ 0 ] ;  
 	 	 	 }  
 	 	 }  
 	 }  
 	 r e t u r n   - 1 ;  
 }      
 / / - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 i n t   S t o p L o s s C h e c k B u y ( )  
 {  
 i n t   a = 0 ;  
 i f ( S t o p L o s s _   = =   1 )   { a   =   S l P o i n t s ; r e t u r n   a ; }  
 i f ( S t o p L o s s _   = =   2 )    
 {  
 d o u b l e   m a 1   =   p e r i o d M A 1   >   0   ?   M a C u s t o m ( h a n d l e 1 , 0 )   :   0 ;          
 d o u b l e   m a 2   =   p e r i o d M A 2   >   0   ?   M a C u s t o m ( h a n d l e 2 , 0 )   :   0 ;  
 d o u b l e   m a 3   =   p e r i o d M A 3   >   0   ?   M a C u s t o m ( h a n d l e 3 , 0 )   :   0 ;  
 i f ( T y p e M A _ = = 1 )   { a   =   ( i n t ) ( ( A S K - m a 1 ) / P o i n t ( s y m b o l _ ) + S l P o i n t s ) ; r e t u r n   a ; }  
 i f ( T y p e M A _ = = 2 )   { a   =   ( i n t ) ( ( A S K - m a 2 ) / P o i n t ( s y m b o l _ ) + S l P o i n t s ) ; r e t u r n   a ; }  
 i f ( T y p e M A _ = = 3 )   { a   =   ( i n t ) ( ( A S K - m a 3 ) / P o i n t ( s y m b o l _ ) + S l P o i n t s ) ; r e t u r n   a ; }  
 }  
 r e t u r n   a ;  
 }  
 / / - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 i n t   S t o p L o s s C h e c k S e l l ( )  
 {  
 i n t   a = 0 ;  
 i f ( S t o p L o s s _   = =   1 )   { a   =   S l P o i n t s ; r e t u r n   a ; }  
 i f ( S t o p L o s s _   = =   2 )    
 {  
 d o u b l e   m a 1   =   p e r i o d M A 1   >   0   ?   M a C u s t o m ( h a n d l e 1 , 0 )   :   0 ;          
 d o u b l e   m a 2   =   p e r i o d M A 2   >   0   ?   M a C u s t o m ( h a n d l e 2 , 0 )   :   0 ;  
 d o u b l e   m a 3   =   p e r i o d M A 3   >   0   ?   M a C u s t o m ( h a n d l e 3 , 0 )   :   0 ;  
 i f ( T y p e M A _ = = 1 )   { a   =   ( i n t ) ( ( m a 1 - B I D ) / P o i n t ( s y m b o l _ ) + S l P o i n t s ) ; r e t u r n   a ; }  
 i f ( T y p e M A _ = = 2 )   { a   =   ( i n t ) ( ( m a 2 - B I D ) / P o i n t ( s y m b o l _ ) + S l P o i n t s ) ; r e t u r n   a ; }  
 i f ( T y p e M A _ = = 3 )   { a   =   ( i n t ) ( ( m a 3 - B I D ) / P o i n t ( s y m b o l _ ) + S l P o i n t s ) ; r e t u r n   a ; }  
 }  
 r e t u r n   a ;  
 }  
  
 i n t   g e s t i o n e T P ( )  
 {  
 i n t   a = 0 ;  
 i f ( T a k e P r o f i t = = 0 ) r e t u r n   a ;  
 i f ( T a k e P r o f i t = = 1 ) a = T p P o i n t s ;  
 r e t u r n   a ;  
 }  
 / / - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 v o i d   B E c h e c k ( )  
 {  
 i f ( B r e a k E v e n = = 0 ) r e t u r n ;  
 i f ( B r e a k E v e n = = 1 )   B E P o i n t s ( B e S t a r t P o i n t s , B e S t e p P o i n t s , m a g i c N u m b e r , C o m m e n ) ;  
 }  
  
 / *  
 i n p u t   i n t             B e S t a r t P o i n t s                         =   2 5 0 0 ;                             / / B e   S t a r t   i n   P o i n t s  
 i n p u t   i n t             B e S t e p P o i n t s                           =     2 0 0 ;                             / / B e   S t e p   i n   P o i n t s * /  
 / / - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 d o u b l e   g e s t i o n e T r a i l S t o p ( )  
 {  
 d o u b l e   T S = 0 ;  
 i f ( T r a i l i n g S t o p = = 0 ) r e t u r n   T S ;  
 i f ( T r a i l i n g S t o p = = 1 ) T s P o i n t s ( T s S t a r t ,   T s S t e p ,   m a g i c N u m b e r ,   C o m m e n ) ;  
 i f ( T r a i l i n g S t o p = = 2 ) P o s i t i o n s T r a i l i n g S t o p I n S t e p ( T s S t a r t , T s S t e p , S y m b o l ( ) , m a g i c N u m b e r , 0 ) ;  
 i f ( T r a i l i n g S t o p = = 3 ) T r a i l S t o p C a n d l e _ ( ) ;  
 r e t u r n   T S ;  
 }  
  
  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                               T r a i l S t o p C a n d l e ( )                                                     |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 d o u b l e   T r a i l S t o p C a n d l e _ ( )  
     {  
     d o u b l e   T s C a n d l e = 0 ;  
       i f ( T i c k e t P r i m o O r d i n e B u y ( m a g i c N u m b e r , C o m m e n ) )  
             T s C a n d l e   =   P o s i t i o n T r a i l i n g S t o p O n C a n d l e ( T i c k e t P r i m o O r d i n e B u y ( m a g i c N u m b e r , C o m m e n ) , T i p o T S C a n d e l e , i n d e x C a n d l e _ , T F C a n d l e , 0 . 0 ) ;  
       i f ( T i c k e t P r i m o O r d i n e S e l l ( m a g i c N u m b e r , C o m m e n ) )  
             T s C a n d l e   =   P o s i t i o n T r a i l i n g S t o p O n C a n d l e ( T i c k e t P r i m o O r d i n e S e l l ( m a g i c N u m b e r , C o m m e n ) , T i p o T S C a n d e l e , i n d e x C a n d l e _ , T F C a n d l e , 0 . 0 ) ;  
     r e t u r n   T s C a n d l e ; }    
      
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                                       I n d i c a t o r s                                                           |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 v o i d   I n d i c a t o r s ( )  
     {  
       c h a r   i n d e x = 0 ;  
           {  
             C h a r t I n d i c a t o r A d d ( 0 , 0 , h a n d l e 1 ) ;      
  
             C h a r t I n d i c a t o r A d d ( 0 , 0 , h a n d l e 2 ) ;  
  
             C h a r t I n d i c a t o r A d d ( 0 , 0 , h a n d l e 3 ) ;  
              
             / / C h a r t I n d i c a t o r A d d ( 0 , 0 , h a n d l e D o m O f f ) ;  
  
             / / i f ( O n C h a r t _ A T R ) { i n d e x   + + ; i n t   i n d i c a t o r _ h a n d l e A T R = i A T R ( S y m b o l ( ) , p e r i o d A T R , A T R _ p e r i o d ) ; C h a r t I n d i c a t o r A d d ( 0 , i n d e x , i n d i c a t o r _ h a n d l e A T R ) ; }                  
           }  
     }      
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 v o i d   r e s e t I n d i c a t o r s ( )  
  
     {  
       i n t   n u m _ w i n d o w s   =   ( i n t ) C h a r t G e t I n t e g e r ( 0 , C H A R T _ W I N D O W S _ T O T A L ) ;  
  
       f o r ( i n t   w i n d o w   =   n u m _ w i n d o w s   -   1 ;   w i n d o w   >   - 1 ;   w i n d o w - - )  
           {  
             i n t   n u m I n d i c a t o r s   =   C h a r t I n d i c a t o r s T o t a l ( 0 ,   w i n d o w ) ;  
  
             f o r ( i n t   i n d e x   =   n u m I n d i c a t o r s ;   i n d e x   > =   0 ;   i n d e x - - )  
                 {  
                   R e s e t L a s t E r r o r ( ) ;  
  
                   s t r i n g   n a m e   =   C h a r t I n d i c a t o r N a m e ( 0 ,   w i n d o w ,   i n d e x ) ;  
  
                   i f ( G e t L a s t E r r o r ( )   ! =   0 )  
                       {  
                         / / P r i n t F o r m a t ( " C h a r t I n d i c a t o r N a m e   e r r o r :   % d " ,   G e t L a s t E r r o r ( ) ) ;  
                         R e s e t L a s t E r r o r ( ) ;  
                       }  
  
                   i f ( ! C h a r t I n d i c a t o r D e l e t e ( 0 ,   w i n d o w ,   n a m e ) )  
                       {  
                         i f ( G e t L a s t E r r o r ( )   ! =   0 )  
                             {  
                               / /     P r i n t F o r m a t ( " D e l e t e   i n d i c a t o r   e r r o r :   % d " ,   G e t L a s t E r r o r ( ) ) ;  
                               R e s e t L a s t E r r o r ( ) ;  
                             }  
                       }  
                   e l s e  
                       {  
                         P r i n t ( " D e l e t e   i n d i c a t o r   w i t h   h a n d l e : " ,   n a m e ) ;  
                       }  
                 }  
           }  
     }    
      
      
      
      
      
      
      
      
      
      
           