/ / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                                                                                     Z i g u l �   v 1 . 2 . m q 5   |  
 / / |                                                                     C o p y r i g h t   2 0 2 4 ,   M e t a Q u o t e s   L t d .   |  
 / / |                                                                                           h t t p s : / / w w w . m q l 5 . c o m   |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
  
 # p r o p e r t y   c o p y r i g h t   " C o r r a d o   B r u n i ,   C o p y r i g h t   � 2 0 2 3 "  
 / / # p r o p e r t y   l i n k             " h t t p s : / / w w w . c b a l g o t r a d e . c o m "  
 # p r o p e r t y   v e r s i o n       " 1 . 2 "  
 # p r o p e r t y   s t r i c t  
 # p r o p e r t y   i n d i c a t o r _ s e p a r a t e _ w i n d o w  
 # p r o p e r t y   d e s c r i p t i o n   " T h e   E x p e r t   A d v i s o r   i s . . . . "  
 # p r o p e r t y   i n d i c a t o r _ b u f f e r s   1  
  
 s t r i n g   v e r s i o n e   =   " v 1 . 2 " ;  
  
 # i n c l u d e   < M y L i b r a r y \ E n u m   D a y   W e e k . m q h >  
 # i n c l u d e   < M y I n c l u d e \ P a t t e r n s _ S q 9 . m q h >  
 # i n c l u d e   < M y L i b r a r y \ M y L i b r a r y . m q h >      
 # i n c l u d e   < C a n v a s \ C h a r t s \ H i s t o g r a m C h a r t . m q h >  
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
 l o n g   N u m e r o A c c o u n t 9   =   N u m e r o A c c o u n t O k [ 9 ]   =   6 2 0 3 9 5 0 0 ;  
  
 e n u m   L i n e T y p e _                       / / T y p e   o f   l i n e s  
     {  
       S o l i d             =   0 ,  
       D a s h               =   1 ,  
       D o t                 =   2 ,  
       D a s h D o t         =   3 ,  
       D a s h D o t D o t   =   4  
     } ;  
  
 e n u m   L i n e W i d t h                     / / L i n e s  
     {  
       V e r y T h i n       =   1 ,  
       T h i n               =   2 ,  
       N o r m a l           =   3 ,  
       T h i c k             =   4 ,  
       V e r y T h i c k     =   5  
     } ;          
 e n u m   S t o p B e f o r e _  
     {  
       c i n q u e M i n                           =     5 ,   / / 5   M i n  
       d i e c i M i n                             =   1 0 ,   / / 1 0   m i n  
       q u i n d M i n                             =   1 5 ,   / / 1 5   m i n  
       t r e n t a M i n                           =   3 0 ,   / / 3 0   m i n  
       q u a r a n t a c i n M i n                 =   4 5 ,   / / 4 5   m i n  
       u n O r a                                   =   6 0 ,   / / 1   H o u r  
       u n O r a e M e z z a                       =   9 0 ,   / / 1 : 3 0   H o u r  
       d u e O r e                                 = 1 2 0 ,   / / 2   H o u r s  
       d u e O r e e M e z z a                     = 1 5 0 ,   / / 2 : 3 0   H o u r s  
       t r e O r e                                 = 1 8 0 ,   / / 3   H o u r s  
       q u a t t r o O r e                         = 2 4 0 ,   / / 4   H o u r s  
     } ;  
 e n u m   S t o p A f t e r _  
     {  
       c i n q u e M i n                           =     5 ,   / / 5   M i n  
       d i e c i M i n                             =   1 0 ,   / / 1 0   m i n  
       q u i n d M i n                             =   1 5 ,   / / 1 5   m i n  
       t r e n t a M i n                           =   3 0 ,   / / 3 0   m i n  
       q u a r a n t a c i n M i n                 =   4 5 ,   / / 4 5   m i n  
       u n O r a                                   =   6 0 ,   / / 1   H o u r  
       u n O r a e M e z z a                       =   9 0 ,   / / 1 : 3 0   H o u r  
       d u e O r e                                 = 1 2 0 ,   / / 2   H o u r s  
       d u e O r e e M e z z a                     = 1 5 0 ,   / / 2 : 3 0   H o u r s  
       t r e O r e                                 = 1 8 0 ,   / / 3   H o u r s  
       q u a t t r o O r e                         = 2 4 0 ,   / / 4   H o u r s  
     } ;      
 e n u m   c a p i t B a s e P e r C o m p o u n d i n g g  
     {  
       E q u i t y                     =   0 ,  
       M a r g i n e _ l i b e r o     =   1 , / / F r e e   m a r g i n  
       B a l a n c e                   =   2 ,  
     } ;  
 e n u m   F u s o _  
     {  
       G M T                             =   0 ,  
       L o c a l                         =   1 ,  
       S e r v e r                       =   2  
     } ;      
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
 e n u m   l e v I m p    
     {  
       i m p u l                                           =   0 ,     / / I m p u l s o  
       l e v e l                                           =   1 ,     / / L i v e l l o  
     } ;    
 e n u m   n M a x P o s  
     {  
       U n a _ p o s i z i o n e       =   1 ,     / / M a x   1   O r d i n e  
       D u e _ p o s i z i o n i       =   2 ,     / / M a x   2   O r d i n i  
     } ;  
  
 e n u m   T y p e _ O r d e r s  
     {  
       B u y _ S e l l                   =   0 ,                               / / O r d e r s   B u y   e   S e l l  
       B u y                             =   1 ,                               / / O n l y   B u y   O r d e r s  
       S e l l                           =   2                                 / / O n l y   S e l l   O r d e r s  
     } ;  
 e n u m   T y p e S l  
     {  
       N o                               =   0 ,                       / / N o   S t o p   L o s s  
       P o i n t s                       =   1 ,                       / / S t o p   L o s s   P o i n t s  
       Z Z P r e c                       =   2 ,                       / / S t o p   L o s s   a l l ' u l t i m o   Z i g Z a g   " A m p i o "  
       Z Z u l t i m o                   =   3 ,                       / / S t o p   L o s s   a l l ' u l t i m o   Z i g   Z a g   M i n i m o  
     } ;    
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
     } ;  
 e n u m   T y p e C a n d l e  
     {  
       S t e s s o                                         =   0 ,     / / T r a i l i n g   S t o p   s u l   m i n / m a x   d e l l a   c a n d e l a   " i n d e x "  
       U n a                                               =   1 ,     / / T r a i l i n g   S t o p   s u l   m i n / m a x   d e l   c o r p o   d e l l a   c a n d e l a   " i n d e x "  
       D u e                                               =   2 ,     / / T r a i l i n g   S t o p   s u l   m a x / m i n   d e l   c o r p o   d e l l a   c a n d e l a   " i n d e x "  
       T r e                                               =   3 ,     / / T r a i l i n g   S t o p   s u l   m a x / m i n   d e l l a   c a n d e l a   " i n d e x "  
     } ;  
            
 e n u m   T p  
     {  
       N o _ T p                                           =   0 ,     / / N o   T p  
       T p P o i n t s                                     =   1 ,     / / T p   i n   P o i n t s  
       T p M A                                             =   2 ,     / / T p   a l l a   M e d i a   M o b i l e  
       T P S o g l i a O o o p s t a                       =   3 ,     / / T p   a l l a   S o g l i a   o p p o s t a  
     } ;  
  
 e n u m   o r d l i v e l l i s u p e r a t i  
     {  
       N o                                                 =   0 ,     / / O r d i n i   c o n s e n t i t i   s e n z a   f i l t r o   l i v e l l o   p r e c e d e n t e  
       o p e n                                             =   1 ,     / / O r d i n i   c o n s e n t i t i   s e   o l t r e   i l   l i v   O p e n   p r e c   e   t i p o   u g u a l e  
       o p e n c l o s e                                   =   2       / / O r d i n i   c o n s e n t i t i   s e   o l t r e   i l   l i v   O p e n / C l o s e   p r e c   e   t i p o   u g u a l e  
     } ;    
      
 e n u m   p e n d M A c o n g r u a  
     {  
       N o                                                 =   0 ,     / / N o  
       t u t t e                                           =   1 ,     / / C o n g r u i t �   p e n d   M A / o r d i n i :   S u   t u t t e   l e   c a n d e l e    
       p r i m a u l t i m a                               =   2       / / C o n g r u i t �   p e n d   M A / o r d i n i :   S u   p r i m a / u l t i m a   c a n d e l e  
     } ;      
      
 e n u m   d i r e z C a n d  
     {  
       / / N o                                                 =   0 ,     / / F l a t  
       c a n d N                                           =   1 ,     / / N �   C a n d e l e   c o n g r u e   c o n   l ' O r d i n e  
       c a n d N e S u p e r a m B o d y                   =   2 ,     / / N �   C a n d e l e   c o n g r u e   e   s u p e r a m   b o d y   c a n d   p r e c e d  
       c a n d N e S u p e r a m S h a d o w               =   3 ,     / / N �   C a n d e l e   c o n g r u e   e   s u p e r a m   s h a d o w   c a n d   p r e c e d  
     } ;    
 e n u m   b o d y S h S w    
     {  
       b o d y S w i n g                           =   0 ,     / / B o d y   c a n d e l a   S w i n g   C h a r t  
       s h a d o w S w i n g                       =   1 ,     / / S h a d o w   c a n d e l a   S w i n g   C h a r t  
     } ;    
 / *        
 e n u m   b o d y S h B o    
     {  
       b o d y B r e a k O u t                     =   0 ,     / / B o d y   c a n d e l a   B r e a k   O u t  
       s h a d o w B r e a k O u t                 =   1 ,     / / S h a d o w   c a n d e l a   B r e a k   O u t  
     } ;      
 * /    
 e n u m   A l e r t T y p e  
     {  
       N o A l e r t                       =   0 ,  
       P l a y S o u n d A l e r t         =   1 ,  
       S h o w A l e r t M e s s a g e     =   2 ,  
       S e n d M o b i l e M e s s a g e   =   3 ,  
       S e n d E m a i l                   =   4  
     } ;  
  
 e n u m   L i n e T y p e  
     {  
       S o l i d             =   0 ,  
       D a s h               =   1 ,  
       D o t                 =   2 ,  
       D a s h D o t         =   3 ,  
       D a s h D o t D o t   =   4  
     } ;  
  
 e n u m   L i n e W i d t h _  
     {  
       V e r y T h i n       =   1 ,  
       T h i n               =   2 ,  
       N o r m a l           =   3 ,  
       T h i c k             =   4 ,  
       V e r y T h i c k     =   5  
     } ;  
  
 e n u m   A l e r t s  
     {  
       R 5     =   0 ,  
       R 4     =   1 ,  
       R 3     =   2 ,  
       R 2     =   3 ,  
       R 1     =   4 ,  
       S 1     =   5 ,  
       S 2     =   6 ,  
       S 3     =   7 ,  
       S 4     =   8 ,  
       S 5     =   9 ,  
     } ;  
  
 e n u m   P r i c e T y p e  
     {  
       P r e v i o u s D a y O p e n     =   0 ,  
       P r e v i o u s D a y L o w       =   1 ,  
       P r e v i o u s D a y H i g h     =   2 ,  
       P r e v i o u s D a y C l o s e   =   3 ,  
       P i v o t P o i n t               =   4 ,  
       C u s t o m                       =   5 ,  
     } ;    
    
 i n p u t   s t r i n g       c o m m e n t _ O S           =                 " - - -   S E T T I N G S   G E N E R A L I   - - - " ;       / /   - - -   S E T T I N G S   G E N E R A L I   - - -  
 i n p u t   i n t   C l o s e O r d D o p o N u m C a n d D a l P r i m o O r d i n e _   =       0 ;                   / / C h i u d e   l ' O r d i n e   s e   i n   p r o f i t t o   d o p o   n �   c a n d e l e .   ( 0   =   D i s a b l e )  
 i n p u t   T y p e _ O r d e r s   T y p e _ O r d e r s _                               =       0 ;                   / / T i p o   d i   O r d i n i  
 i n p u t   n M a x P o s           N _ M a x _ p o s                                     =       1 ;                   / / M a s s i m o   n u m e r o   d i   O r d i n i   c o n t e m p o r a n e a m e n t e  
 i n p u t   u l o n g               m a g i c _ n u m b e r                               =   4 4 4 4 ;                 / / M a g i c   N u m b e r  
 i n p u t   s t r i n g             C o m m e n                                           =   " Z i g u l �   v 1 . 2 " ;               / / C o m m e n t  
 i n p u t   i n t                   D e v i a z i o n e                                   =       0 ;                   / / S l i p p a g e      
  
 i n p u t   s t r i n g       c o m m e n t _ S t r a t       =               " - - -   O R D I N I   A D   I M P U L S O / L I V E L L O   - - - " ;       / /   - - -   O R D I N I   A D   I M P U L S O / L I V E L L O   - - -  
 / / i n p u t   b o o l           S w i n g C h a r t                                     =   f a l s e ;               / / S w i n g   C h a r t  
 i n p u t   l e v I m p       l e v e l I m p u l s                                       =           0 ;               / / I m p u l s o   /   L i v e l l o  
  
 i n p u t   s t r i n g       c o m m e n t p a t t c a n d   =               " - - -   O R D I N I   P A T T E R N   C A N D E L E   C O N G R U E / B O D Y / / S H A D O W   - - - " ;       / /   - - -   O R D I N I   P A T T E R N   C A N D E L E   C O N G R U E / B O D Y / / S H A D O W   - - -  
 i n p u t   d i r e z C a n d     d i r e z C a n d _                                     =           1 ;               / / P e r m e t t e   O r d i n e   C a n d   a   f a v o r e :   N o / N � C a n d / N � C a n d + B o d y / N � C a n d + S h a d o w  
 i n p u t   i n t             n u m C a n d D i r e z                                     =           1 ;               / / N u m e r o   C a n d e l e   a   f a v o r e .   M i n i m o   1 .  
 i n p u t   E N U M _ T I M E F R A M E S   t i m e F r C a n d   =       P E R I O D _ C U R R E N T ;                 / / T i m e   F r a m e   C a n d e l e  
  
 i n p u t   s t r i n g       c o m m e n t _ D I F           =               " - - -   F I L T R O   D I S T A N Z A   M I N I M A   P I C C H I   - - - " ;       / /   - - -   F I L T R O   D I S T A N Z A   M I N I M A   P I C C H I   - - -  
 i n p u t   i n t             d i s t p i c c h i                                         =     1 0 0 0 ;               / / D i s t a n z a   m i n i m a   t r a   i   p i c c h i  
  
 i n p u t   s t r i n g       c o m m e n t _ O R D           =               " - - -   F I L T R O   I N C L I N A Z I O N E   - - - " ;       / /   - - -   F I L T R O   I N C L I N A Z I O N E   - - -  
 i n p u t   d o u b l e       i n c l i n a z m i n                                       =       1 0 0 ;               / / O r d i n i   c o n s e n t i t i   d a l l ' i n c l i n a z i o n e   Z i g Z a g  
  
 i n p u t   s t r i n g       c o m m e n t _ L I V           =     " - - - -   O R D I N I   A   %   L I V E L L I   e   O L T R E   L I V E L L I   O R D I N I   P R E C E D E N T I   - - - - " ;       / /   - - - -   O R D I N I   A   %   L I V E L L I   e   O L T R E   L I V E L L I   O R D I N I   P R E C E D E N T I   - - - -  
 i n p u t   i n t             p e r c l e v l e v                                         =         6 5 ;               / / O r d i n i   c o n s e n t i t i   f i n o   a l l a   %   t r a   s o g l i e        
 i n p u t   o r d l i v e l l i s u p e r a t i   o r d l i v e l l i s u p e r a t i _   =           0 ;               / / N u o v i   O r d i n i   a   l i v e l l i   o l t r e   O p e n / C l o s e      
  
 i n p u t   s t r i n g       c o m m e n t _ M e             =               " - - -   F I L T R O   P E N D E N Z A   M A   C O N G R U A   - - - " ;       / /   - - -   F I L T R O   P E N D E N Z A   M A   C O N G R U A   - - -  
 i n p u t   p e n d M A c o n g r u a   p e n d m a c o n g r u a               =       0 ;                             / / P e n d   c o n g r u a   M A / O r d :   N O / T u t t e   l e   c a n d / S o l o   p r i m a / u l t i m a   ( M i n   2 )  
 i n p u t   i n t             n u m c a n d M a c o n g r u e                   =       2 ;                             / / N u m e r o   d i   c a n d e l e   M A   p e r   d e t e r m i n a r e   l a   p e n d e n z a    
  
 i n p u t   s t r i n g       c o m m e n t C a n d S w i n g =               " - - -   C A N D E L A   D I   S W I N G   - - - " ;       / /   - - -   C A N D E L A   D I   S W I N G   - - -  
 i n p u t   b o d y S h S w   b o d y S h a d o w S w                                     =           0 ;               / / S u p e r a m e n t o   B o d y   /   S h a d o w   S w i n g   C h a r t  
 i n p u t   E N U M _ T I M E F R A M E S   t i m e F r P i c c o     =   P E R I O D _ C U R R E N T ;                 / /   T i m e   f r a m e   c a n d e l a   d i   P i c c o   Z i g   Z a g  
  
 i n p u t   s t r i n g       c o m m e n t _ Z Z             =               " - - -   Z I G   Z A G   S E T T I N G   - - - " ; / /   - - -   Z I G   Z A G   S E T T I N G   - - -                                                                
 i n p u t   i n t             I n p D e p t h                                   =   1 2 ;                               / /   Z i g Z a g :   D e p t h  
 i n p u t   i n t             I n p D e v i a t i o n                           =     5 ;                               / /   Z i g Z a g :   D e v i a t i o n  
 i n p u t   i n t             I n p B a c k s t e p                             =     3 ;                               / /   Z i g Z a g :   B a c k s t e p  
 i n p u t   i n t         I n p C a n d l e s C h e c k                         = 2 0 0 ;                               / /   Z i g Z a g :   n u m e r o   c a n d e l e   a n a l i z z a t e  
 i n p u t   i n t             M i n C a n d Z Z                                 =     0 ;                               / /   M i n i m o   d i   c a n d e l e   p e r   a p p r o v a r e   i l   v a l o r e   d e l l ' u l t i m o   Z i g Z a g  
 i n p u t   E N U M _ T I M E F R A M E S   p e r i o d Z i g z a g = P E R I O D _ C U R R E N T ;                     / /   T i m e f r a m e   Z i g Z a g  
  
 i n p u t   s t r i n g       c o m m e n t _ M A   =                 " - - -   M A   S E T T I N G   - - - " ;         / /   - - -   M A   S E T T I N G   - - -  
 i n p u t   i n t                                     p e r i o d M A F a s t     =   3 0 ;                             / / P e r i o d o   M A    
 i n p u t   i n t                                     s h i f t M A F a s t       =     0 ;                             / / S h i f t   M A    
 i n p u t   E N U M _ M A _ M E T H O D               m e t h o d M A F a s t = M O D E _ E M A ;                       / / M e t o d o   M A    
 i n p u t   E N U M _ A P P L I E D _ P R I C E       a p p l i e d _ p r i c e M A F a s t = P R I C E _ C L O S E ;   / / T i p o   d i     p r e z z o   M A    
 i n p u t   c o l o r                                 c o l o r e M A F a s t   =   c l r A z u r e ;                   / / C o l o r e   M A    
  
 i n p u t   s t r i n g           c o m m e n t _ G 9   =             " - - -   S q u a r e   o f   9   S E T T I N G   - - - " ;         / /   - - -   S q u a r e   o f   9   S E T T I N G   - - -  
 i n p u t   P r i c e T y p e     G a n n I n p u t T y p e               =   4 ;  
 i n p u t   s t r i n g           G a n n C u s t o m P r i c e           =   " " ;  
 i n p u t   i n t                 G a n n I n p u t D i g i t             =   6 ;  
 i n p u t   b o o l               S h o r t L i n e s                     =   t r u e ;  
 i n p u t   b o o l               S h o w L i n e N a m e                 =   t r u e ;  
 i n p u t   A l e r t T y p e     A l e r t 1                             =   0 ;  
 i n p u t   A l e r t T y p e     A l e r t 2                             =   0 ;  
 i n p u t   i n t                 P i p D e v i a t i o n                 =   3 ;  
 i n p u t   s t r i n g           C o m m e n t S t y l e                 =   " - - -   S t y l e   S e t t i n g s   - - - " ;  
 i n p u t   b o o l               D r a w B a c k g r o u n d             =   t r u e ;  
 i n p u t   b o o l               D i s a b l e S e l e c t i o n         =   t r u e ;  
 i n p u t   c o l o r             R e s i s t a n c e C o l o r           =   c l r R e d ;  
 i n p u t   L i n e T y p e       R e s i s t a n c e T y p e             =   2 ;  
 i n p u t   L i n e W i d t h     R e s i s t a n c e W i d t h           =   1 ;  
 i n p u t   c o l o r             S u p p o r t C o l o r                 =   c l r G r e e n ;  
 i n p u t   L i n e T y p e       S u p p o r t T y p e                   =   2 ;  
 i n p u t   L i n e W i d t h     S u p p o r t W i d t h                 =   1 ;  
 i n p u t   s t r i n g           B u t t o n S t y l e   =   " - - -   T o g g l e   S t y l e   S e t t i n g s   - - - " ;  
 i n p u t   b o o l               B u t t o n E n a b l e   =   f a l s e ;  
 i n p u t   i n t                 X D i s t a n c e   =   2 5 0 ;  
 i n p u t   i n t                 Y D i s t a n c e   =   5 ;  
 i n p u t   i n t                 W i d t h   =   1 0 0 ;  
 i n p u t   i n t                 H i g h t   =   3 0 ;  
 i n p u t   s t r i n g           L a b e l   =   " G a n n " ;  
  
 i n p u t   s t r i n g       c o m m e n t _ S L   =                       " - - -   S T O P   L O S S   - - - " ;     / /   - - -   S T O P   L O S S   - - -  
 i n p u t   T y p e S l       T y p e S l _                                     =           1 ;                         / / S t o p   L o s s :   N o   /   S l   P o i n t s   /   P i c c o   Z i g Z a g   P r e c e d e n t e  
 i n p u t   i n t             S l P o i n t s                                   =   1 0 0 0 0 ;                         / / S t o p   l o s s   P o i n t s .  
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
 i n p u t   s t r i n g       c o m m e n t _ T S C   =                       " - - -   T R A I L I N G   S T O P   C A N D L E   - - - " ;       / /   - - -   T R A I L I N G   S T O P   C A N D L E - - -  
 i n p u t   T y p e C a n d l e   T y p e C a n d l e _                         =         0 ;                             / / T y p e   T r a i l i n g   S t o p   C a n d l e  
 i n p u t   i n t               i n d e x C a n d l e _                         =         1 ;                             / / I n d e x   C a n d l e   P r e v i o u s  
 i n p u t   E N U M _ T I M E F R A M E S   T F C a n d l e                     =         P E R I O D _ C U R R E N T ;   / / T i m e   f r a m e   C a n d l e   T o p / B o t t o m  
  
 i n p u t   s t r i n g       c o m m e n t _ T P   =                       " - - -   T A K E   P R O F I T   - - - " ;   / /   - - -   T A K E   P R O F I T   - - -  
 i n p u t   T p               T a k e P r o f i t                               =         1 ;                             / / T a k e   P r o f i t :   N o / P o i n t s / M A / B o d y   c a n d   o p p o s t a / S h a d   c a n d   o p p  
 i n p u t   i n t             T p P o i n t s                                   =   1 0 0 0 ;                             / / T a k e   P r o f i t   P o i n t s  
  
 i n p u t   s t r i n g       c o m m e n t _ A T R   =                         " - - -   A T R   S E T T I N G   - - - " ;     / /   - - -   A T R   S E T T I N G   - - -  
 i n p u t   b o o l                                   F i l t e r _ A T R       =   f a l s e ;                                 / / F i l t e r   A T R   E n a b l e  
 i n p u t   b o o l                                   O n C h a r t _ A T R     =   f a l s e ;                                 / / O n   c h a r t  
 i n p u t   i n t                                     A T R _ p e r i o d = 1 4 ;                                               / / P e r i o d   A T R  
 i n p u t   E N U M _ T I M E F R A M E S             p e r i o d A T R = P E R I O D _ C U R R E N T ;                         / / T i m e f r a m e  
 i n p u t   d o u b l e                               t h e s h o l d A T R     =   1 . 7 5 5 ;                                 / / T h e s h o l d   A T R :   A T R   a b o v e   t h e   t h r e s h o l d   e n a b l e s   t r a d i n g  
  
 i n p u t   s t r i n g       c o m m e n t _ M M                     =   " - - -   M O N E Y   M A N A G E M E N T   - - - " ; / /   - - -   M O N E Y   M A N A G E M E N T   - - -  
 i n p u t   b o o l           E n a b l e A l l o c a z i o n e       =       f a l s e ;                                       / / A b i l i t a / d i s a b i l i t a   l ' a l l o c a z i o n e   d i   c a p i t a l e  
 i n p u t   d o u b l e       c a p i t a l T o A l l o c a t e E A   =     	 	   0 ; 	 	 	 	 	         / / C a p i t a l e   d a   a l l o c a r e   p e r   l ' E A   ( 0   =   i n t e r o   c a p i t a l e )  
 i n p u t   b o o l           c o m p o u n d i n g                   =         t r u e ;                                       / / C o m p o u n d i n g  
 i n p u t   c a p i t B a s e P e r C o m p o u n d i n g g   c a p i t B a s e P e r C o m p o u n d i n g 1   =   0 ;         / / R e f e r e n c e   c a p i t a l   f o r   C o m p o u n d i n g  
 i n p u t   d o u b l e       l o t s E A                             =           0 . 1 ;                                       / / L o t s  
 i n p u t   d o u b l e       r i s k E A                             =               0 ;                                       / / R i s k   i n   %   [ 0 - 1 0 0 ]  
 i n p u t   d o u b l e       r i s k D e n a r o E A                 =               0 ;                                       / / R i s k   i n   m o n e y  
 i n p u t   d o u b l e       c o m m i s s i o n i                   =               4 ;                                       / / C o m m i s s i o n s   p e r   l o t  
  
 i n p u t   s t r i n g           c o m m e n t _ C H A R T   =             " - - -   S E T T I N G   C H A R T   - - - " ;       / /   - - -   S E T T I N G   C H A R T   - - -  
 i n p u t   b o o l               s h o r t L i n e s                           =   t r u e ;           / / L i n e e   c o r t e  
 i n p u t   b o o l               S H o w L i n e N a m e                       =   t r u e ;           / / N o m e   l i n e a  
 i n p u t   b o o l               D R a w B a c k g r o u n d                   =   t r u e ;    
 i n p u t   b o o l               D I s a b l e S e l e c t i o n               =   t r u e ;        
 i n p u t   c o l o r             c o l o r e s e l l                           =   c l r G o l d ;     / / C o l o r e   S o g l i e  
 i n p u t   c o l o r             c o l o r e b u y                             =   c l r L i m e ;     / / C o l o r e   M a x   B u y / M i n   S e l l  
 i n p u t   L i n e T y p e _     t i p o d i l i n e a                         =   2 ;                 / / T i p o   d i   l i n e a  
 i n p u t   L i n e W i d t h _     S p e s s o r e l i n e a                     =   1 ;                 / / S p e s s o r e   l i n e a  
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
 b o o l       A c c u m u l a t i v e             =                   t r u e ;  
  
 u l o n g     m a g i c N u m b e r               =   m a g i c _ n u m b e r ;       / /   M a g i c   N u m b e r  
  
 d o u b l e   c a p i t a l T o A l l o c a t e   =                         0 ;  
 b o o l         a u t o T r a d i n g O n O f f   =   	           t r u e ;  
  
 d o u b l e   c a p i t a l e B a s e P e r C o m p o u n d i n g ;  
 d o u b l e   d i s t a n z a S L   =   0 ;  
  
 d o u b l e   A S K   =   0 ;  
 d o u b l e   B I D   =   0 ;  
  
 s t r i n g   s y m b o l _   =   S y m b o l ( ) ;  
  
 b o o l   s e m C a n d   =   f a l s e ;  
  
 i n t   s p r e a d ;  
 s t r i n g   C o m m e n t o   =   " " ;  
 b o o l   e n a b l e T r a d i n g   =   t r u e ;  
  
 d a t e t i m e   O r a N e w s ;  
  
 i n t   h a n d l e A T R ;  
 i n t   h a n d l e _ i C u s t o m M A F a s t ;  
 i n t   H a n d l e _ i C u s t o m Z i g Z a g ;  
 i n t   H a n d l e _ i C u s t o m S Q 9 ;  
 d o u b l e   S q 9 B u f f e r [ ] ;  
  
 i n t   I n d e x Z Z [ 1 0 0 ] ;  
 d o u b l e   V a l Z Z [ 1 0 0 ] ;  
 d o u b l e   u l t i m o P i k ;  
  
 s t a t i c   d o u b l e   s o g l i a S u p , s o g l i a I n f = 0 ;  
 s t r i n g   P c o d e = " Z i g u l �   " ;  
 s t a t i c     b o o l   d a t i S o g l i e   =   f a l s e ;  
  
 s t a t i c   d o u b l e   p i c c o a l t o   =   0 ,   p i c c o b a s s o   =   0 ;  
  
 s t a t i c   i n t   c o n t a U n o   =   0 ;  
  
 d o u b l e   s o g l i a b u y c o n s   =   0 ,   s o g l i a s e l l c o n s   =   0 ;  
 d o u b l e   i n c l i n o m e t r   =   0 ;  
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
 	 C l e a r O b j ( ) ;  
       h a n d l e _ i C u s t o m M A F a s t       =   i C u s t o m ( s y m b o l _ , 0 , " E x a m p l e s \ \ C u s t o m   M o v i n g   A v e r a g e   I n p u t   C o l o r " , p e r i o d M A F a s t , s h i f t M A F a s t , m e t h o d M A F a s t , c o l o r e M A F a s t ) ;      
  
       H a n d l e _ i C u s t o m Z i g Z a g       =   i C u s t o m ( s y m b o l _ , p e r i o d Z i g z a g , " E x a m p l e s \ \ Z i g Z a g " , I n p D e p t h , I n p D e v i a t i o n , I n p B a c k s t e p ) ;  
   / *      
       H a n d l e _ i C u s t o m S Q 9             =   i C u s t o m ( s y m b o l _ , 0 , " G a n n   S q   9   I n d i c a t o r \ \ G a n n _ P i v o t s _ 2 " , G a n n I n p u t T y p e , ( s t r i n g ) V a l Z Z [ 0 ] , G a n n I n p u t D i g i t , S h o r t L i n e s , S h o w L i n e N a m e , A l e r t 1 , A l e r t 2 , P i p D e v i a t i o n ,  
                                                                         C o m m e n t S t y l e , D r a w B a c k g r o u n d , D i s a b l e S e l e c t i o n , R e s i s t a n c e C o l o r , R e s i s t a n c e T y p e , R e s i s t a n c e W i d t h , S u p p o r t C o l o r , S u p p o r t T y p e , S u p p o r t W i d t h , B u t t o n S t y l e ,  
                                                                         B u t t o n E n a b l e , X D i s t a n c e , Y D i s t a n c e , W i d t h , H i g h t , L a b e l ) ; * /  
  
       A r r a y S e t A s S e r i e s ( S q 9 B u f f e r , t r u e ) ;  
  
       s o g l i a S u p = 0 ; s o g l i a I n f = 0 ; d a t i S o g l i e   =   f a l s e ;  
       c o n t a U n o   =   0 ;  
        
       r e t u r n ( I N I T _ S U C C E E D E D ) ;  
     }  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |   E x p e r t   d e i n i t i a l i z a t i o n   f u n c t i o n                                                                   |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 v o i d   O n D e i n i t ( c o n s t   i n t   r e a s o n )  
     {  
 r e s e t I n d i c a t o r s ( ) ;  
 C l e a r O b j ( ) ;  
 C o m m e n t ( " " ) ;        
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
 / / i f ( ! I s M a r k e t T r a d e O p e n ( s y m b o l _ ) | | I s M a r k e t Q u o t e C l o s e d ( s y m b o l _ ) )   r e t u r n ;  
 e n a b l e T r a d i n g   =   I s M a r k e t T r a d e O p e n ( s y m b o l _ )   & &   ! I s M a r k e t Q u o t e C l o s e d ( s y m b o l _ )   & &   G e s t i o n e A T R ( ) ;            
  
 A S K = A s k ( s y m b o l _ ) ;  
 B I D = B i d ( s y m b o l _ ) ;  
 s t a t i c   d a t e t i m e   t i m e s o g l i a s u p   =   0 ;  
 s t a t i c   d a t e t i m e   t i m e s o g l i a i n f   =   0 ;  
  
 s t r i n g   i n c l i n a z e n a b l e   =   " " ;  
 i f ( i n c l i n a z m i n > i n c l i n o m e t r )   i n c l i n a z e n a b l e   =   " L ' I n c l i n a z i o n e   N O N   C O N S E N T E   N u o v i   O r d i n i " ;  
 C o m m e n t o   =   s p r e a d C o m m e n t ( )   +   " \ n B a r r e   n e l   g r a f i c o   "   +   ( s t r i n g ) n u m B a r r e I n C h a r t ( )   +   " \ n \ n I n c l i n a z i o n e   M i n i m a   c o n s e n t i t a   " + ( s t r i n g ) i n c l i n a z m i n + " \ n I n c l i n a z i o n e   R e a l e   " + ( s t r i n g ) i n c l i n o m e t r + " \ n " + i n c l i n a z e n a b l e ;  
  
 s e m C a n d   =   s e m a f o r o C a n d e l a ( 0 ) ;    
  
 A r r a y I n i t i a l i z e ( I n d e x Z Z , 0 ) ;  
 A r r a y I n i t i a l i z e ( V a l Z Z , 0 ) ;  
  
 z i g z a g P i c c h i ( I n p D e p t h , I n p D e v i a t i o n , I n p B a c k s t e p , I n p C a n d l e s C h e c k , 0 , p e r i o d Z i g z a g , V a l Z Z , I n d e x Z Z ) ;    
 u l t i m o P i k   =   V a l Z Z [ 0 ] ;          
 P r i n t ( " U l t i m o P i k   " , u l t i m o P i k ) ;  
  
 H a n d l e _ i C u s t o m S Q 9   =   i C u s t o m ( s y m b o l _ , 0 , " G a n n   S q   9   I n d i c a t o r \ \ G a n n _ P i v o t s " , G a n n I n p u t T y p e , ( s t r i n g ) u l t i m o P i k , G a n n I n p u t D i g i t , S h o r t L i n e s , S h o w L i n e N a m e , A l e r t 1 , A l e r t 2 , P i p D e v i a t i o n ,  
                                                                         C o m m e n t S t y l e , D r a w B a c k g r o u n d , D i s a b l e S e l e c t i o n , R e s i s t a n c e C o l o r , R e s i s t a n c e T y p e , R e s i s t a n c e W i d t h , S u p p o r t C o l o r , S u p p o r t T y p e , S u p p o r t W i d t h , B u t t o n S t y l e ,  
                                                                         B u t t o n E n a b l e , X D i s t a n c e , Y D i s t a n c e , W i d t h , H i g h t , L a b e l ) ;  
          
          
          
 A r r a y I n i t i a l i z e ( S q 9 B u f f e r , 0 ) ;                                                              
 i n t   c o p y 1 = C o p y B u f f e r ( H a n d l e _ i C u s t o m S Q 9 , 1 , 0 , 1 0 , S q 9 B u f f e r ) ; i f ( c o p y 1 < = 0 ) P r i n t ( " I l   t e n t a t i v o   d i   o t t e n e r e   i   v a l o r i   d i   C u s t o m   G a n n   S q   9   I n d i c a t o r   �   f a l l i t o " ) ;    
  
  
  
  
  
  
  
 I n d i c a t o r s ( ) ;  
  
 C l o s e O r d e r D o p o N u m C a n d ( C l o s e O r d D o p o N u m C a n d D a l P r i m o O r d i n e _ , m a g i c N u m b e r ) ;        
 c l o s e O r d i n e M A ( M A F a s t ( 0 ) , m a g i c _ n u m b e r , C o m m e n ) ;  
 g e s t i o n e B r e a k E v e n ( ) ;  
 g e s t i o n e T r a i l S t o p ( ) ;  
 i f ( s e m C a n d   | |   ! c o n t a U n o )   { g e s t i o n e O r d i n i ( t i m e s o g l i a s u p , t i m e s o g l i a i n f ) ; c o n t a U n o + + ; }  
  
 i f ( s h o r t L i n e s ) D R a w R e c t a n g l e L i n e ( t i m e s o g l i a s u p , t i m e s o g l i a i n f ) ;  
 e l s e   d r a w H o r i z o n t a l L e v e l ( ) ;  
 W R i t e L i n e N a m e ( ) ;  
 / / H i s t o g r a m ( ) ;  
 C o m m e n t ( C o m m e n t o ) ;  
 / / P r i n t ( " S o g l i a %   B u y   " , ( ( s o g l i a S u p - s o g l i a I n f ) / 1 0 0 * p e r c l e v l e v ) + s o g l i a I n f ) ; P r i n t ( " S o g l i a %   S e l l   " , s o g l i a S u p - ( ( s o g l i a S u p - s o g l i a I n f ) / 1 0 0 * p e r c l e v l e v ) ) ;  
 / / i f ( s e m C a n d ) P r i n t ( "   u l t i m o p i c c o   B U Y   " , u l t i m o p i c c o ( " B u y " ) , "   u l t i m o p i c c o   S E L L   " , u l t i m o p i c c o ( " S e l l " ) ) ;  
  
 }      
  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                                 g e s t i o n e O r d i n i ( )                                                     |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +      
 v o i d   g e s t i o n e O r d i n i ( d a t e t i m e   & t i m e s o g l i a s u p , d a t e t i m e   & t i m e s o g l i a i n f )  
 {  
 	 i f ( ! a u t o T r a d i n g O n O f f   | |   ! e n a b l e T r a d i n g )   r e t u r n ;  
 	  
 	 A l l o c a z i o n e _ C h e c k ( m a g i c N u m b e r ) ;      
      
 i f ( T i m e L i c e n s   <   T i m e C u r r e n t ( ) ) { A l e r t ( " E A :   T r i a l   p e r i o d   e x p i r e d !   R e m o v e d   E A   f r o m   t h i s   a c c o u n t ! " ) ;  
             P r i n t ( " E A :   T r i a l   p e r i o d   e x p i r e d !   R e m o v e d   E A   f r o m   t h i s   a c c o u n t ! " ) ;  
             A l e r t ( " E A :   T r i a l   p e r i o d   e x p i r e d !   R e m o v e d   E A   f r o m   t h i s   a c c o u n t ! " ) ;  
             E x p e r t R e m o v e ( ) ; }  
 s t a t i c   d o u b l e   S t L o s s Z z P r e c e d B u y   =   0 , S t L o s s Z z P r e c e d S e l l   =   0 ;  
  
 b o o l   i m p u l s o L i v B u y   =   t r u e , i m p u l s o L i v S e l l   =   t r u e ;  
       i m p u l s o L i v e l l o ( i m p u l s o L i v B u y , i m p u l s o L i v S e l l ) ;  
 / *    
 A r r a y I n i t i a l i z e ( I n d e x Z Z , 0 ) ;  
 A r r a y I n i t i a l i z e ( V a l Z Z , 0 ) ;  
 u l t i m o P i k   =   z i g z a g P i c c h i ( I n p D e p t h , I n p D e v i a t i o n , I n p B a c k s t e p , I n p C a n d l e s C h e c k , 0 , p e r i o d Z i g z a g , V a l Z Z , I n d e x Z Z ) ;    
  
  
 H a n d l e _ i C u s t o m S Q 9             =   i C u s t o m ( s y m b o l _ , 0 , " G a n n   S q   9   I n d i c a t o r \ \ G a n n _ P i v o t s " , G a n n I n p u t T y p e , ( s t r i n g ) u l t i m o P i k , G a n n I n p u t D i g i t , S h o r t L i n e s , S h o w L i n e N a m e , A l e r t 1 , A l e r t 2 , P i p D e v i a t i o n ,  
                                                                         C o m m e n t S t y l e , D r a w B a c k g r o u n d , D i s a b l e S e l e c t i o n , R e s i s t a n c e C o l o r , R e s i s t a n c e T y p e , R e s i s t a n c e W i d t h , S u p p o r t C o l o r , S u p p o r t T y p e , S u p p o r t W i d t h , B u t t o n S t y l e ,  
                                                                         B u t t o n E n a b l e , X D i s t a n c e , Y D i s t a n c e , W i d t h , H i g h t , L a b e l ) ;      
 i n t   c o p y 1 = C o p y B u f f e r ( H a n d l e _ i C u s t o m S Q 9 , 0 , 0 , 1 0 , S q 9 B u f f e r ) ; i f ( c o p y 1 < = 0 ) P r i n t ( " I l   t e n t a t i v o   d i   o t t e n e r e   i   v a l o r i   d i   C u s t o m   G a n n   S q   9   I n d i c a t o r   �   f a l l i t o " ) ;    
  
 f o r ( i n t   i = 0 ; i < 1 0 ; i + + )  
 { P r i n t ( i , "   " , S q 9 B u f f e r [ i ] ) ; }  
 * /  
                                                                            
 / / b o o l   p e n d c o n g r u a b u y   =   t r u e , p e n d c o n g r u a s e l l   =   t r u e ;        
        
 / / P r i n t ( "   I n c l i n o m e t r o   " , i n c l i n o m e t r ) ;  
 / / P r i n t ( " p e n d c o n g r u a m a B u y :   " , p e n d c o n g r u a m a B u y ( ) ) ;  
  
             i n c l i n o m e t r o ( i n c l i n o m e t r ) ;  
  
 i f (  
             d i s t a n z a m i n i m a p i c c h i ( d i s t p i c c h i )  
       & &   s o g l i a B u y S e l l ( " B u y " , S t L o s s Z z P r e c e d B u y , t i m e s o g l i a s u p , t i m e s o g l i a i n f )  
       & &   o r d i n i _ T i p o _ N u m M a x (   " B u y " , T y p e _ O r d e r s _ , N _ M a x _ p o s , m a g i c N u m b e r , C o m m e n )  
       & &   n u m C a n d e l e C o n g r u e ( d i r e z C a n d _ , " B u y " , n u m C a n d D i r e z , t i m e F r C a n d )  
       & &   i m p u l s o L i v B u y  
       & &   p e n d c o n g r u a m a B u y ( )  
       & &   i n c l i n o m e t r o ( i n c l i n o m e t r )  
       )  
       {  
       S e n d T r a d e B u y I n P o i n t ( s y m b o l _ , l o t s E A , D e v i a z i o n e , c a l c o l o S t o p L o s s ( " B u y " ) , c a l c o l o T a k e P r o f ( " B u y " ) , C o m m e n , m a g i c _ n u m b e r ) ;  
       }                                          
  
 / / P r i n t ( " p e n d c o n g r u a S e l l :   " , p e n d c o n g r u a m a S e l l ( ) ) ;  
 i f (  
             d i s t a n z a m i n i m a p i c c h i ( d i s t p i c c h i )  
       & &   s o g l i a B u y S e l l ( " S e l l " , S t L o s s Z z P r e c e d S e l l , t i m e s o g l i a s u p , t i m e s o g l i a i n f )    
       & &   o r d i n i _ T i p o _ N u m M a x ( " S e l l " , T y p e _ O r d e r s _ , N _ M a x _ p o s , m a g i c N u m b e r , C o m m e n )  
       & &   n u m C a n d e l e C o n g r u e ( d i r e z C a n d _ , " S e l l " , n u m C a n d D i r e z , t i m e F r C a n d )  
       & &   i m p u l s o L i v S e l l  
       & &   p e n d c o n g r u a m a S e l l ( )  
       & &   i n c l i n o m e t r o ( i n c l i n o m e t r )  
       )  
       {  
       S e n d T r a d e S e l l I n P o i n t ( s y m b o l _ , l o t s E A , D e v i a z i o n e , c a l c o l o S t o p L o s s ( " S e l l " ) , c a l c o l o T a k e P r o f ( " S e l l " ) , C o m m e n , m a g i c _ n u m b e r ) ;  
       }  
 }      
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                   d i s t a n z a m i n i m a p i c c h i ( )                                                       |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +    
 b o o l   d i s t a n z a m i n i m a p i c c h i ( i n t   d i s t p i c c h i _ )  
 {  
 r e t u r n   ( d i s t p i c c h i _   <   M a t h A b s ( V a l Z Z [ 0 ]   -   V a l Z Z [ 1 ] ) / P o i n t ( s y m b o l _ ) ) ;  
 }  
  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                                 s o g l i a B u y S e l l ( )                                                       |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +    
 b o o l   s o g l i a B u y S e l l ( s t r i n g   B u y S e l l , d o u b l e   & S l Z Z P r e c e d e n t e ,   d a t e t i m e   & t i m e P i c c o A l t o ,   d a t e t i m e   & t i m e P i c c o B a s s o )  
 {  
 b o o l   a   =   f a l s e ;  
  
 d o u b l e   C 1   =   0 , H 1   =   0 , L 1   =   0 ;    
 i f ( s e m C a n d )   { C 1   =   i C l o s e ( s y m b o l _ , P E R I O D _ C U R R E N T , 1 ) ; H 1   =   i H i g h ( s y m b o l _ , P E R I O D _ C U R R E N T , 1 ) ; L 1   =   i L o w ( s y m b o l _ , P E R I O D _ C U R R E N T , 1 ) ; }  
  
 s t a t i c     i n t   i n d e x S o g l i a S u p = 0 ;   s t a t i c   i n t   i n d e x S o g l i a I n f = 0 ;  
  
  
 i f ( d a t i S o g l i e = = f a l s e )  
 {  
    
   i f ( V a l Z Z [ 0 ] = = 0   | |   V a l Z Z [ 1 ] = = 0   | |   V a l Z Z [ 2 ] = = 0 )  
           { P r i n t ( " P i c c o   0   " , V a l Z Z [ 0 ] , " P i c c o   1   " , V a l Z Z [ 1 ] , " P i c c o   2   " , V a l Z Z [ 2 ] , " D a t i   Z i g   Z a g   I n c o m p l e t i .   C o n t r o l l a r e   n u m e r o   c a n d e l e   B a c k t e s t " ) ;  
             C o m m e n t o = C o m m e n t o + ( s t r i n g ) "   N o   d a t i   Z i g   Z a g .   C o n t r o l l a r e   n u m e r o   c a n d e l e   B a c k t e s t " ; } ;  
    
  
  
 i f ( V a l Z Z [ 0 ] > 0   & &   V a l Z Z [ 1 ] > 0   & &   V a l Z Z [ 2 ] > 0   & &   d o u b l e C o m p r e s o ( V a l Z Z [ 0 ] , V a l Z Z [ 1 ] , V a l Z Z [ 2 ] )   & &   d a t i S o g l i e = = f a l s e )  
 {  
 	 i f ( V a l Z Z [ 1 ] > V a l Z Z [ 2 ] )   { s o g l i a S u p   =   p i c c o a l t o   =   V a l Z Z [ 1 ] ; i n d e x S o g l i a S u p = I n d e x Z Z [ 1 ] ;   s o g l i a I n f   =   p i c c o b a s s o   =   V a l Z Z [ 2 ] ; i n d e x S o g l i a I n f = I n d e x Z Z [ 2 ] ; }    
 	 i f ( V a l Z Z [ 1 ] < V a l Z Z [ 2 ] )   { s o g l i a S u p   =   p i c c o a l t o   =   V a l Z Z [ 2 ] ; i n d e x S o g l i a S u p = I n d e x Z Z [ 2 ] ;   s o g l i a I n f   =   p i c c o b a s s o   =     V a l Z Z [ 1 ] ; i n d e x S o g l i a I n f = I n d e x Z Z [ 1 ] ; }    
 } 	  
 	  
 	  
 i f ( V a l Z Z [ 0 ] > 0   & &   V a l Z Z [ 1 ] > 0   & &   V a l Z Z [ 2 ] > 0   & &   ! d o u b l e C o m p r e s o ( V a l Z Z [ 0 ] , V a l Z Z [ 1 ] , V a l Z Z [ 2 ] )   & &   d a t i S o g l i e = = f a l s e )  
 {  
 	 i f ( V a l Z Z [ 0 ] > V a l Z Z [ 1 ] )   { s o g l i a S u p   =   p i c c o a l t o   =   V a l Z Z [ 0 ] ; i n d e x S o g l i a S u p = I n d e x Z Z [ 0 ] ;   s o g l i a I n f   =   p i c c o b a s s o   =     V a l Z Z [ 1 ] ; i n d e x S o g l i a I n f = I n d e x Z Z [ 1 ] ; }    
 	 i f ( V a l Z Z [ 0 ] < V a l Z Z [ 1 ] )   { s o g l i a S u p   =   p i c c o a l t o   =   V a l Z Z [ 1 ] ; i n d e x S o g l i a S u p = I n d e x Z Z [ 1 ] ;   s o g l i a I n f   =   p i c c o b a s s o   =     V a l Z Z [ 0 ] ; i n d e x S o g l i a I n f = I n d e x Z Z [ 0 ] ; }  
 } 	 	  
  
  
 t i m e P i c c o A l t o   =   i T i m e ( s y m b o l _ , p e r i o d Z i g z a g , i n d e x S o g l i a S u p ) ;  
 t i m e P i c c o B a s s o =   i T i m e ( s y m b o l _ , p e r i o d Z i g z a g , i n d e x S o g l i a I n f ) ;  
  
 i n d e x S o g l i a S u p = i B a r S h i f t ( s y m b o l _ , t i m e F r P i c c o , t i m e P i c c o A l t o ) ;  
 i n d e x S o g l i a I n f = i B a r S h i f t ( s y m b o l _ , t i m e F r P i c c o , t i m e P i c c o B a s s o ) ;  
  
  
 i f ( ! b o d y S h a d o w S w )   / / B o d y  
 {  
 i f ( c a n d e l a N u m I s B u y O S e l l T F ( i n d e x S o g l i a S u p , " B u y " , t i m e F r P i c c o ) )   s o g l i a S u p   =   i O p e n ( s y m b o l _ , t i m e F r P i c c o , i n d e x S o g l i a S u p ) ;    
 i f ( c a n d e l a N u m I s B u y O S e l l T F ( i n d e x S o g l i a S u p , " S e l l " , t i m e F r P i c c o ) ) s o g l i a S u p   =   i C l o s e ( s y m b o l _ , t i m e F r P i c c o , i n d e x S o g l i a S u p ) ;  
  
 i f ( c a n d e l a N u m I s B u y O S e l l T F ( i n d e x S o g l i a I n f , " B u y " , t i m e F r P i c c o ) )   s o g l i a I n f   =   i C l o s e ( s y m b o l _ , t i m e F r P i c c o , i n d e x S o g l i a I n f ) ;  
 i f ( c a n d e l a N u m I s B u y O S e l l T F ( i n d e x S o g l i a I n f , " S e l l " , t i m e F r P i c c o ) ) s o g l i a I n f   =   i O p e n ( s y m b o l _ , t i m e F r P i c c o , i n d e x S o g l i a I n f ) ;  
 }  
  
 i f ( b o d y S h a d o w S w )   / / S h a d o w  
 {  
 s o g l i a S u p   =   i L o w ( s y m b o l _ , t i m e F r P i c c o , i n d e x S o g l i a S u p ) ;  
 s o g l i a I n f   =   i H i g h ( s y m b o l _ , t i m e F r P i c c o , i n d e x S o g l i a I n f ) ;  
 }  
  
 i f ( s o g l i a S u p   & &   s o g l i a I n f )   d a t i S o g l i e   =   t r u e ;   / / e l s e ( P r i n t ( " N o   d a t i   s o g l i e " ) ) ;  
 }  
  
 i f ( d a t i S o g l i e   & &   ( H 1 > p i c c o a l t o   | |   L 1 < p i c c o b a s s o ) )   { d a t i S o g l i e = f a l s e ;  
 s o g l i a S u p = 0 ; s o g l i a I n f = 0 ; i n d e x S o g l i a I n f = i n d e x S o g l i a S u p = 0 ; p i c c o a l t o = p i c c o b a s s o = 0 ; a = 0 ;  
 r e t u r n   a ; } / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / /  
  
 i f ( s o g l i a S u p   <   s o g l i a I n f ) { C o m m e n t o = C o m m e n t o + " \ n \ n   S o g l i a   S u p e r i o r e   i n f e r i o r e   a l l a   S o g l i a   I n f e r i o r e :   N o   O p e n   O r d e r " ;  
                                                       P r i n t ( " S o g l i a   S u p e r i o r e   i n f e r i o r e   a l l a   S o g l i a   I n f e r i o r e :   N o   O p e n   O r d e r " ) ;   a   =   f a l s e ; r e t u r n   a ; }  
  
 b o o l   p e r c S o g l i a S o g l i a B u y     =   p e r c s o g l i a s o g l i a ( " B u y " ) ;  
 b o o l   p e r c S o g l i a S o g l i a S e l l   =   p e r c s o g l i a s o g l i a ( " S e l l " ) ;  
  
 i f (  
                   / / i n c l i n o m e t r o ( i n c l i n o m e t r )   & &    
                   p a s s a s o g l i a p r i m a ( " B u y " )   & &   B u y S e l l = = " B u y "     & &   p e r c S o g l i a S o g l i a B u y   & &   C 1 > s o g l i a I n f    
             & &   C 1 < s o g l i a S u p   & &   n u m C a n d e l e C o n g r u e ( d i r e z C a n d _ , " B u y " ,   n u m C a n d D i r e z , t i m e F r C a n d ) )    
             { a   =   t r u e ;  
             / / P r i n t ( "   C o n g r u e   B U Y   " ) ;  
               r e t u r n   a ; }  
  
 i f (  
                   / / i n c l i n o m e t r o ( i n c l i n o m e t r )   & &    
                   p a s s a s o g l i a p r i m a ( " S e l l " )   & &   B u y S e l l = = " S e l l "   & &   p e r c S o g l i a S o g l i a S e l l   & &   C 1 < s o g l i a S u p    
             & &   C 1 > s o g l i a I n f   & &   n u m C a n d e l e C o n g r u e ( d i r e z C a n d _ , " S e l l " , n u m C a n d D i r e z , t i m e F r C a n d ) )    
             { a   =   t r u e ;  
             / / P r i n t ( "   C o n g r u e   S E L L   " ) ;  
               r e t u r n   a ; }  
  
 r e t u r n   a ;  
 }  
 / / - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   p e n d c o n g r u a m a B u y ( )   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 b o o l   p e n d c o n g r u a m a B u y ( )  
 {  
 b o o l   a   =   t r u e ;  
  
 i f ( n u m c a n d M a c o n g r u e < 2 ) { A l e r t ( " I m p o s t a z i o n e   \ " n u m e r o   c a n d e l e   x   p e n d e n z a   c o n g r u a \ "   E R R A T A .   M i n i m o   \ " 2 \ " ! " ) ; r e t u r n   a ; }  
 i f ( p e n d m a c o n g r u a = = 0 ) r e t u r n   a ;  
  
 d o u b l e   L a b e l B u f f e r 1 [ ] ;  
  
 A r r a y I n i t i a l i z e ( L a b e l B u f f e r 1 , 0 ) ; A r r a y S e t A s S e r i e s ( L a b e l B u f f e r 1 , t r u e ) ;  
 i n t   c o p y 1 = C o p y B u f f e r ( h a n d l e _ i C u s t o m M A F a s t , 0 , 1 , n u m c a n d M a c o n g r u e , L a b e l B u f f e r 1 ) ; i f ( c o p y 1 < = 0 ) P r i n t ( " I l   t e n t a t i v o   d i   o t t e n e r e   i   v a l o r i   d i   C u s t o m   M o v i n g   A v e r a g e   �   f a l l i t o " ) ;  
 / *  
 f o r ( i n t   i = 0 ; i < A r r a y S i z e ( L a b e l B u f f e r 1 ) ; i + + )  
 {  
 P r i n t ( i , "   " , L a b e l B u f f e r 1 [ i ] ) ; }  
 * /  
 i f ( p e n d m a c o n g r u a = = 1 )  
 {  
 f o r ( i n t   i = 0 ; i < n u m c a n d M a c o n g r u e - 1 ; i + + )  
 {  
 / / P r i n t ( "   L a b e l B u f f e r 1   B U Y   " , i   , "   " , L a b e l B u f f e r 1 [ i ] , "   L a b e l B u f f e r 1   B U Y   " , i + 1 , "   " ,   L a b e l B u f f e r 1 [ i + 1 ] ) ;  
 i f ( L a b e l B u f f e r 1 [ i ] > L a b e l B u f f e r 1 [ i + 1 ]   & &   i > = n u m c a n d M a c o n g r u e - 2 )   { a   =   t r u e ; r e t u r n   a ; }  
 i f ( L a b e l B u f f e r 1 [ i ] < L a b e l B u f f e r 1 [ i + 1 ] )   { a   =   f a l s e ; r e t u r n   a ; }  
 }  
 }  
 i f ( p e n d m a c o n g r u a = = 2 )  
 {  
 / / i f ( L a b e l B u f f e r 1 [ 0 ] > L a b e l B u f f e r 1 [ n u m c a n d M a c o n g r u e - 1 ] )   { a   =   t r u e ; r e t u r n   a ; }  
 i f ( L a b e l B u f f e r 1 [ 0 ] < L a b e l B u f f e r 1 [ n u m c a n d M a c o n g r u e - 1 ] )   { a   =   f a l s e ; r e t u r n   a ; }  
 }  
 r e t u r n   a ;  
 }  
 / / - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   p e n d c o n g r u a m a S e l l ( )   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 b o o l   p e n d c o n g r u a m a S e l l ( )  
 {  
 b o o l   a   =   t r u e ;  
 i f ( n u m c a n d M a c o n g r u e < 2 ) { A l e r t ( " I m p o s t a z i o n e   \ " n u m e r o   c a n d e l e   x   p e n d e n z a   c o n g r u a \ "   E R R A T A .   M i n i m o   \ " 2 \ " ! " ) ; r e t u r n   a ; }  
 i f ( p e n d m a c o n g r u a = = 0 ) r e t u r n   a ;  
  
 d o u b l e   L a b e l B u f f e r 1 [ ] ;  
  
 A r r a y I n i t i a l i z e ( L a b e l B u f f e r 1 , 1 ) ; A r r a y S e t A s S e r i e s ( L a b e l B u f f e r 1 , t r u e ) ;  
 i n t   c o p y 1 = C o p y B u f f e r ( h a n d l e _ i C u s t o m M A F a s t , 0 , 1 , n u m c a n d M a c o n g r u e , L a b e l B u f f e r 1 ) ; i f ( c o p y 1 < = 0 ) P r i n t ( " I l   t e n t a t i v o   d i   o t t e n e r e   i   v a l o r i   d i   C u s t o m   M o v i n g   A v e r a g e   �   f a l l i t o " ) ;  
  
 i f ( p e n d m a c o n g r u a = = 1 )  
 {  
 f o r ( i n t   i = 0 ; i < n u m c a n d M a c o n g r u e - 1 ; i + + )  
 {  
 / / P r i n t ( "   L a b e l B u f f e r 1   S E L L   " , i   , "   " , L a b e l B u f f e r 1 [ i ] , "   L a b e l B u f f e r 1   S E L L   " , i + 1 , "   " , L a b e l B u f f e r 1 [ i + 1 ] ) ;  
 i f ( L a b e l B u f f e r 1 [ i ] < L a b e l B u f f e r 1 [ i + 1 ]   & &   i > = n u m c a n d M a c o n g r u e - 2 )   { a   =   t r u e ; r e t u r n   a ; }  
 i f ( L a b e l B u f f e r 1 [ i ] > L a b e l B u f f e r 1 [ i + 1 ] )   { a   =   f a l s e ; r e t u r n   a ; }  
 }  
 }  
 i f ( p e n d m a c o n g r u a = = 2 )  
 {  
 / / i f ( L a b e l B u f f e r 1 [ 0 ] < L a b e l B u f f e r 1 [ n u m c a n d M a c o n g r u e - 1 ] )   { a   =   t r u e ; r e t u r n   a ; }  
 i f ( L a b e l B u f f e r 1 [ 0 ] > L a b e l B u f f e r 1 [ n u m c a n d M a c o n g r u e - 1 ] )   { a   =   f a l s e ; r e t u r n   a ; }  
 }  
 r e t u r n   a ;  
 }  
 / / - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   i m p u l s o L i v e l l o ( )   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    
 v o i d   i m p u l s o L i v e l l o ( b o o l   & I m p L i v B u y , b o o l   & I m p L i v S e l l )  
 {  
  
 i f ( l e v e l I m p u l s = = 1 ) { I m p L i v B u y = t r u e ; I m p L i v S e l l = t r u e ; }  
  
 i f ( l e v e l I m p u l s = = 0 )  
 {  
 / / i f ( s o g l i a S u p = = 0   | |   s o g l i a I n f = = 0 )   { a   =   f a l s e ; r e t u r n   a ; }  
 d o u b l e   C 1   =   i C l o s e ( s y m b o l _ , P E R I O D _ C U R R E N T , 1 ) ;  
 s t a t i c   s t r i n g   t i p o u l t i m o O r d i n e   =   " F l a t " ;  
  
 s t a t i c   d o u b l e   o l d s o g l i a s u p   =   0 ,   o l d s o g l i a i n f   =   0 ;  
 i n t       o r d b u y     =   N u m O r d B u y ( m a g i c N u m b e r , C o m m e n ) ;  
 i n t       o r d s e l l   =   N u m O r d S e l l ( m a g i c N u m b e r , C o m m e n ) ;  
  
  
 i f ( ! o r d b u y   & &   ! o r d s e l l   & &   t i p o u l t i m o O r d i n e   = =   " F l a t " )  
 {  
 i f ( d o u b l e C o m p r e s o ( C 1 , s o g l i a I n f , s o g l i a b u y c o n s ) ) { I m p L i v B u y   =   t r u e ; }  
  
 i f ( d o u b l e C o m p r e s o ( C 1 , s o g l i a S u p , s o g l i a s e l l c o n s ) ) { I m p L i v S e l l   =   t r u e ; }  
 }  
  
  
 i f ( o r d b u y )  
 {  
 i f ( I m p L i v B u y   & &   t i p o u l t i m o O r d i n e   ! =   " B u y " ) { I m p L i v B u y   =   f a l s e ;   t i p o u l t i m o O r d i n e = " B u y " ; o l d s o g l i a s u p   =   s o g l i a S u p ;   o l d s o g l i a i n f   =   s o g l i a I n f ; }  
  
 i f ( t i p o u l t i m o O r d i n e   = =   " B u y " )   { I m p L i v B u y   =   f a l s e ; }  
  
 i f ( t i p o u l t i m o O r d i n e   = =   " B u y "   & &   C 1   <   s o g l i a I n f )   { I m p L i v B u y   =   t r u e ; }  
  
 i f ( t i p o u l t i m o O r d i n e   = =   " B u y "   & &   ( s o g l i a S u p   ! =   o l d s o g l i a s u p   | |   s o g l i a I n f   ! =   o l d s o g l i a i n f ) )   { t i p o u l t i m o O r d i n e = " F l a t " ; I m p L i v B u y   =   t r u e ; }  
 }  
  
 i f ( ! o r d b u y )  
 {  
 i f ( t i p o u l t i m o O r d i n e   = =   " B u y "   & &   C 1   <   s o g l i a I n f )   { t i p o u l t i m o O r d i n e   =   " F l a t " ; I m p L i v B u y   =   t r u e ; }  
  
 i f ( t i p o u l t i m o O r d i n e   = =   " B u y "   & &   ( s o g l i a S u p   ! =   o l d s o g l i a s u p   | |   s o g l i a I n f   ! =   o l d s o g l i a i n f ) )   { t i p o u l t i m o O r d i n e   =   " F l a t " ; I m p L i v B u y   =   t r u e ; }  
  
 i f ( t i p o u l t i m o O r d i n e   = =   " B u y "   & &   s o g l i a S u p   = =   o l d s o g l i a s u p   & &   s o g l i a I n f   = =   o l d s o g l i a i n f )   { I m p L i v B u y   =   f a l s e ; }  
  
 i f ( t i p o u l t i m o O r d i n e   ! =   " B u y "   & &   ( s o g l i a S u p   ! =   o l d s o g l i a s u p   | |   s o g l i a I n f   ! =   o l d s o g l i a i n f ) )   { I m p L i v B u y   =   t r u e ; }  
 }  
 / / P r i n t ( " t i p o   O r d :   " , t i p o u l t i m o O r d i n e , "   s o g l i a s u p   " , s o g l i a S u p , "   s o g l i a i n f   " , s o g l i a I n f , "   I m p L i v B u y   " , I m p L i v B u y ) ;  
  
  
 i f ( o r d s e l l )  
 {  
 i f ( I m p L i v S e l l   & &   t i p o u l t i m o O r d i n e   ! =   " S e l l " ) { I m p L i v S e l l   =   f a l s e ;   t i p o u l t i m o O r d i n e = " S e l l " ; o l d s o g l i a s u p   =   s o g l i a S u p ;   o l d s o g l i a i n f   =   s o g l i a I n f ; }  
  
 i f ( t i p o u l t i m o O r d i n e   = =   " S e l l "   & &   s o g l i a S u p   = =   o l d s o g l i a s u p   & &   s o g l i a I n f   = =   o l d s o g l i a i n f   & &   I m p L i v S e l l )   { I m p L i v S e l l   =   f a l s e ; }  
  
 i f ( t i p o u l t i m o O r d i n e   = =   " S e l l "   & &   C 1   >   s o g l i a S u p )   { t i p o u l t i m o O r d i n e = " F l a t " ; I m p L i v S e l l   =   t r u e ; }  
  
 i f ( t i p o u l t i m o O r d i n e   = =   " S e l l "   & &   ( s o g l i a S u p   ! =   o l d s o g l i a s u p   | |   s o g l i a I n f   ! =   o l d s o g l i a i n f ) )   { t i p o u l t i m o O r d i n e = " F l a t " ; I m p L i v S e l l   =   t r u e ; }  
 }  
  
 i f ( ! o r d s e l l )  
 {  
 i f ( t i p o u l t i m o O r d i n e   = =   " S e l l "   & &   C 1   >   s o g l i a S u p )   { t i p o u l t i m o O r d i n e   =   " F l a t " ; I m p L i v S e l l   =   t r u e ; }  
  
 i f ( t i p o u l t i m o O r d i n e   = =   " S e l l "   & &   ( s o g l i a S u p   ! =   o l d s o g l i a s u p   | |   s o g l i a I n f   ! =   o l d s o g l i a i n f ) )   { t i p o u l t i m o O r d i n e   =   " F l a t " ; I m p L i v S e l l   =   t r u e ; }  
  
 i f ( t i p o u l t i m o O r d i n e   = =   " S e l l "   & &   s o g l i a S u p   = =   o l d s o g l i a s u p   & &   s o g l i a I n f   = =   o l d s o g l i a i n f )   { I m p L i v S e l l   =   f a l s e ; }  
  
 i f ( t i p o u l t i m o O r d i n e   ! =   " S e l l "   & &   ( s o g l i a S u p   ! =   o l d s o g l i a s u p   | |   s o g l i a I n f   ! =   o l d s o g l i a i n f ) )   { I m p L i v S e l l   =   t r u e ; }  
 }  
 / / P r i n t ( " t i p o   O r d :   " , t i p o u l t i m o O r d i n e , "   s o g l i a s u p   " , s o g l i a S u p , "   s o g l i a i n f   " , s o g l i a I n f , "   I m p L i v S e l l   " , I m p L i v S e l l ) ;  
 }  
 }  
  
 / / P e n d e n z a C a n d e l e ( )  
 / / - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   O r d l i v s u p e r a t i ( )   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    
 b o o l   O r d l i v s u p e r a t i ( s t r i n g   B u y S e l l )  
 {  
 b o o l   a   =   t r u e ;  
 i f ( ! o r d l i v e l l i s u p e r a t i _ )   r e t u r n   a ;  
 u l o n g   t i k b u y = T i c k e t P r i m o O r d i n e B u y ( m a g i c _ n u m b e r ,   C o m m e n ) , t i k s e l l = T i c k e t P r i m o O r d i n e S e l l ( m a g i c _ n u m b e r ,   C o m m e n ) ;  
 i f ( ! t i k b u y   & &   ! t i k s e l l )   r e t u r n   a ;  
 s t a t i c   d o u b l e   o p e n b u y   =   0 , o p e n s e l l   =   0 ;  
 s t a t i c   u l o n g   T i k B u y   =   0 , T i k S e l l   =   0 ;  
 d o u b l e   C 1   =   i C l o s e ( s y m b o l _ , P E R I O D _ C U R R E N T , 1 ) ;  
  
 i f ( o r d l i v e l l i s u p e r a t i _ = = 1 )  
 {  
 i f ( B u y S e l l = = " B u y " )  
 {  
 i f ( t i k b u y   & &   ! o p e n b u y ) { o p e n s e l l = 0 ; o p e n b u y = P o s i t i o n O p e n P r i c e ( t i k b u y ) ; T i k B u y = t i k b u y ; }  
 i f ( T i k B u y ! = t i k b u y   & &   P o s i t i o n O p e n P r i c e ( t i k b u y ) < = o p e n b u y ) { a = f a l s e ; r e t u r n   a ; }  
 }  
 i f ( B u y S e l l = = " S e l l " )  
 {  
 i f ( t i k s e l l   & &   ! o p e n s e l l ) { o p e n b u y = 0 ; o p e n s e l l = P o s i t i o n O p e n P r i c e ( t i k s e l l ) ; T i k S e l l = t i k s e l l ; }  
 i f ( T i k S e l l ! = t i k s e l l   & &   P o s i t i o n O p e n P r i c e ( t i k s e l l ) < = o p e n s e l l ) { a = f a l s e ; r e t u r n   a ; }  
 }  
 }  
  
 i f ( o r d l i v e l l i s u p e r a t i _ = = 2 )  
 {  
 s t a t i c   d o u b l e   h i g h b u y   =   0 , l o w s e l l   =   0 ;  
 i f ( B u y S e l l = = " B u y " ) {  
 i f ( t i k b u y   & &   ! o p e n b u y ) { o p e n s e l l = 0 ; o p e n b u y = P o s i t i o n O p e n P r i c e ( t i k b u y ) ; T i k B u y = t i k b u y ; }  
 i f ( T i k B u y ! = t i k b u y   & &   C 1 < v a l o r e S u p e r i o r e ( o p e n b u y , H i s t o r y D e a l P r i c e C l o s e ( T i k B u y ) ) ) { a = f a l s e ; r e t u r n   a ; }  
 }  
 i f ( B u y S e l l = = " S e l l " ) {  
 i f ( t i k s e l l   & &   ! o p e n s e l l ) { o p e n b u y = 0 ; o p e n s e l l = P o s i t i o n O p e n P r i c e ( t i k s e l l ) ; T i k S e l l = t i k s e l l ; }  
 i f ( T i k S e l l ! = t i k s e l l   & &   C 1 > v a l o r e I n f e r i o r e ( o p e n s e l l , H i s t o r y D e a l P r i c e C l o s e ( T i k S e l l ) ) ) { a = f a l s e ; r e t u r n   a ; }  
 }  
 }  
 / / H i s t o r y D e a l P r i c e C l o s e ( )  
 r e t u r n   a ;  
 }  
 / / - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   u l t i m o p i c c o ( )   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    
 d o u b l e   u l t i m o p i c c o ( s t r i n g   o r d B u y S e l l )  
 {  
 d o u b l e   a   =   0 ;  
  
 i n t   b a r r a   =   0 ;  
 f o r ( i n t   i = 0 ; i < A r r a y S i z e ( V a l Z Z ) ; i + + )  
 { i f ( o r d B u y S e l l = = " B u y "     & &   V a l Z Z [ i ]   ! =   0   & &   I n d e x Z Z [ i ]   ! =   0   & &   t i p o p i c c o z i g z a g ( V a l Z Z [ i ] , I n d e x Z Z [ i ] , p e r i o d Z i g z a g ) = = " D w " )   { a   =   V a l Z Z [ i ] ; b a r r a   =   I n d e x Z Z [ i ] ; r e t u r n   a ; }  
   i f ( o r d B u y S e l l = = " S e l l "   & &   V a l Z Z [ i ]   ! =   0   & &   I n d e x Z Z [ i ]   ! =   0   & &   t i p o p i c c o z i g z a g ( V a l Z Z [ i ] , I n d e x Z Z [ i ] , p e r i o d Z i g z a g ) = = " U p " )   { a   =   V a l Z Z [ i ] ; b a r r a   =   I n d e x Z Z [ i ] ; r e t u r n   a ; }  
 }  
 r e t u r n   a ;  
 }  
  
 / / - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   i n c l i n o m e t r o ( )   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    
 b o o l   i n c l i n o m e t r o ( d o u b l e   & i n c l i n o m e t r o )  
 {  
 b o o l   a   =   f a l s e ;  
  
 i f ( V a l Z Z [ 0 ]   >   V a l Z Z [ 1 ] )   { i n c l i n o m e t r o   =   ( V a l Z Z [ 0 ]   -   V a l Z Z [ 1 ] ) / ( I n d e x Z Z [ 1 ]   -   I n d e x Z Z [ 0 ] ) * 1 0 0 0 ; }  
 i f ( V a l Z Z [ 0 ]   <   V a l Z Z [ 1 ] )   { i n c l i n o m e t r o   =   ( V a l Z Z [ 1 ]   -   V a l Z Z [ 0 ] ) / ( I n d e x Z Z [ 1 ]   -   I n d e x Z Z [ 0 ] ) * 1 0 0 0 ; }  
  
 i f ( i n c l i n a z m i n   <   i n c l i n o m e t r o   & &   V a l Z Z [ 0 ] > 0   & &   V a l Z Z [ 1 ] > 0 )   a   =   t r u e ;  
  
   r e t u r n   a ;  
 }  
 / / - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   p e r c s o g l i a s o g l i a ( )   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    
 b o o l   p e r c s o g l i a s o g l i a ( s t r i n g   B u y S e l l )  
 {  
 b o o l   a   =   f a l s e ;  
 d o u b l e   C 1   =   i C l o s e ( s y m b o l _ , P E R I O D _ C U R R E N T , 1 ) ;  
 s o g l i a b u y c o n s     =   ( ( s o g l i a S u p - s o g l i a I n f ) / 1 0 0 * p e r c l e v l e v ) + s o g l i a I n f ; / / P r i n t ( " s o g l i a b u y c o n s   " , s o g l i a b u y c o n s ) ;  
 s o g l i a s e l l c o n s   =   ( s o g l i a S u p - ( s o g l i a S u p - s o g l i a I n f ) / 1 0 0 * p e r c l e v l e v ) ; / / P r i n t ( " s o g l i a s e l l c o n s   " , s o g l i a s e l l c o n s ) ;  
 i f ( B u y S e l l = = " B u y "     & &   p a s s a s o g l i a p r i m a ( " B u y " )     & &   C 1 < =   ( ( s o g l i a S u p - s o g l i a I n f ) / 1 0 0 * p e r c l e v l e v ) + s o g l i a I n f ) { a = t r u e ; r e t u r n   a ; }  
 i f ( B u y S e l l = = " S e l l "   & &   p a s s a s o g l i a p r i m a ( " S e l l " )   & &   C 1 > =   ( s o g l i a S u p - ( s o g l i a S u p - s o g l i a I n f ) / 1 0 0 * p e r c l e v l e v ) ) { a = t r u e ; r e t u r n   a ; }  
 r e t u r n   a ;  
 }  
 / / - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   p a s s a s o g l i a p r i m a ( )   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    
 b o o l   p a s s a s o g l i a p r i m a ( s t r i n g   B u y S e l l )  
 {  
 b o o l   a   =   f a l s e ;  
 s t a t i c   s t r i n g   p r i m a   =   " F l a t " ;  
  
 i f ( i O p e n ( s y m b o l _ , P E R I O D _ C U R R E N T , 1 ) < s o g l i a I n f   & &   i C l o s e ( s y m b o l _ , P E R I O D _ C U R R E N T , 1 ) > s o g l i a I n f )   { p r i m a   =   " B u y " ; }  
 i f ( i O p e n ( s y m b o l _ , P E R I O D _ C U R R E N T , 1 ) > s o g l i a S u p   & &   i C l o s e ( s y m b o l _ , P E R I O D _ C U R R E N T , 1 ) < s o g l i a S u p )   { p r i m a   =   " S e l l " ; }  
 i f ( B u y S e l l = = " B u y "   & &   p r i m a   = =   " B u y " )   { a   =   t r u e ; r e t u r n   a ; }  
  
 i f ( B u y S e l l = = " S e l l "   & &   p r i m a   = =   " S e l l " )   { a   =   t r u e ; r e t u r n   a ; }  
  
 r e t u r n   a ;  
 }  
 / / - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   u l t i m o Z i g Z a g ( )   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    
 d o u b l e   p i c c o z i g z a g a m p i o ( s t r i n g   B u y S e l l )  
 {  
 d o u b l e   a   =   0 ;  
 i f ( B u y S e l l = = " B u y " )   a   =   v a l o r e I n f e r i o r e ( p i c c o a l t o , p i c c o b a s s o ) ;  
 i f ( B u y S e l l = = " S e l l " )   a   =   v a l o r e S u p e r i o r e ( p i c c o a l t o , p i c c o b a s s o ) ;  
 r e t u r n   a ;  
 }  
  
  
  
 / / - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   M A F a s t ( ) - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    
 d o u b l e   M A F a s t ( i n t   i n d e x )  
     {  
       d o u b l e   a   = 0 ;  
       i f ( h a n d l e _ i C u s t o m M A F a s t > I N V A L I D _ H A N D L E )  
           {  
             d o u b l e   v a l o r i M A F a s t [ ] ;  
             i f ( C o p y B u f f e r ( h a n d l e _ i C u s t o m M A F a s t , 0 , i n d e x , 1 , v a l o r i M A F a s t ) > 0 ) { a   =   v a l o r i M A F a s t [ 0 ] ; }  
           }  
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
    
 / / - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   c a l c o l o S t o p L o s s ( ) - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    
 i n t   c a l c o l o S t o p L o s s ( s t r i n g   B u y S e l l )  
 {  
 i n t   a = 0 ;  
 i f ( T y p e S l _ = = 0 ) { a = 0 ; r e t u r n   a ; }  
 i f ( T y p e S l _ = = 1 ) { a = S l P o i n t s ; r e t u r n   a ; }  
 i f ( T y p e S l _ = = 2 )  
 {  
 d o u b l e   C 1   =   i C l o s e ( s y m b o l _ , P E R I O D _ C U R R E N T , 1 ) ;  
 i f ( B u y S e l l = = " B u y " )   { a = ( i n t ) ( ( C 1 - p i c c o z i g z a g a m p i o ( " B u y " ) ) / P o i n t ( ) ) ; r e t u r n   a ; }  
 i f ( B u y S e l l = = " S e l l " )   { a = ( i n t ) ( ( p i c c o z i g z a g a m p i o ( " S e l l " ) - C 1 ) / P o i n t ( ) ) ; r e t u r n   a ; }  
 }  
 i f ( T y p e S l _ = = 3 )  
 {  
 d o u b l e   C 1   =   i C l o s e ( s y m b o l _ , P E R I O D _ C U R R E N T , 1 ) ;  
 i f ( B u y S e l l = = " B u y " )   { a = ( i n t ) ( ( C 1 - u l t i m o p i c c o ( B u y S e l l ) ) / P o i n t ( ) ) ; r e t u r n   a ; }  
 i f ( B u y S e l l = = " S e l l " )   { a = ( i n t ) ( ( u l t i m o p i c c o ( B u y S e l l ) - C 1 ) / P o i n t ( ) ) ; r e t u r n   a ; }  
 }  
 r e t u r n   a ;  
 }  
 / / - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   c a l c o l o T a k e P r o f ( ) - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    
 i n t   c a l c o l o T a k e P r o f ( s t r i n g   B u y S e l l )  
 {  
 i n t   T P = 0 ;  
 i f ( ! T a k e P r o f i t ) r e t u r n   T P ;  
 i f ( T a k e P r o f i t = = 1 ) { T P = T p P o i n t s ; r e t u r n   T P ; }  
  
 i f ( T a k e P r o f i t = = 3   & &   B u y S e l l = = " B u y " ) { T P = ( i n t ) ( ( s o g l i a S u p - B I D ) / P o i n t ( ) ) ; r e t u r n   T P ; }  
 i f ( T a k e P r o f i t = = 3   & &   B u y S e l l = = " S e l l " ) { T P = ( i n t ) ( ( A S K - s o g l i a I n f ) / P o i n t ( ) ) ; r e t u r n   T P ; }  
 r e t u r n   T P ;  
 }  
 / / - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   g e s t i o n e B r e a k E v e n ( ) - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    
 d o u b l e   g e s t i o n e B r e a k E v e n ( )  
 {  
 d o u b l e   B r e a k E v = 0 ;  
 i f ( B r e a k E v e n = = 0 ) r e t u r n   B r e a k E v ;  
 i f ( B r e a k E v e n = = 1 ) B r E v e n ( B e S t a r t P o i n t s ,   B e S t e p P o i n t s ,   m a g i c _ n u m b e r ,   C o m m e n ) ;  
 i f ( B r e a k E v e n = = 2 ) B e P e r c ( B e P e r c S t a r t , B e P e r c S t e p , m a g i c _ n u m b e r , C o m m e n ) ;  
 r e t u r n   B r e a k E v ;  
 }  
  
 / / - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   g e s t i o n e T r a i l S t o p ( ) - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    
 d o u b l e   g e s t i o n e T r a i l S t o p ( )  
 {  
 d o u b l e   T S = 0 ;  
 i f ( T r a i l i n g S t o p = = 0 ) r e t u r n   T S ;  
 i f ( T r a i l i n g S t o p = = 1 ) T s P o i n t s ( T s S t a r t ,   T s S t e p ,   m a g i c _ n u m b e r ,   C o m m e n ) ;  
 i f ( T r a i l i n g S t o p = = 2 ) P o s i t i o n s T r a i l i n g S t o p I n S t e p ( T s S t a r t , T s S t e p , S y m b o l ( ) , m a g i c _ n u m b e r , 0 ) ; / / / P o s i t i o n T r a i l i n g S t o p I n S t e p  
 / / i f ( T r a i l i n g S t o p = = 2 ) { P o s i t i o n T r a i l i n g S t o p I n S t e p ( T i c k e t P r i m o O r d i n e B u y ( m a g i c _ n u m b e r ) , T s S t a r t , T s S t e p ) ; P o s i t i o n T r a i l i n g S t o p I n S t e p ( T i c k e t P r i m o O r d i n e S e l l ( m a g i c _ n u m b e r ) , T s S t a r t , T s S t e p ) ; }  
 i f ( T r a i l i n g S t o p = = 3 ) T r a i l S t o p C a n d l e _ ( ) ;  
 i f ( T r a i l i n g S t o p = = 4 ) T r a i l S t o p P e r c ( T s P e r c S t a r t , T s P e r c S t e p , m a g i c _ n u m b e r , C o m m e n ) ;  
 r e t u r n   T S ;  
 }  
  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                                 c l o s e O r d i n e M A ( )                                                       |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 v o i d   c l o s e O r d i n e M A ( d o u b l e   v a l M A , u l o n g   m a g i c , s t r i n g   c o m m e n t )  
 {  
 i f ( T a k e P r o f i t = = 2 )   c h i u d e O r d i n e M A ( v a l M A , m a g i c , c o m m e n t ) ;  
 }  
  
  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                               T r a i l S t o p C a n d l e ( )                                                     |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 d o u b l e   T r a i l S t o p C a n d l e _ ( )  
     {  
     d o u b l e   T s C a n d l e = 0 ;  
       i f ( T i c k e t P r i m o O r d i n e B u y ( m a g i c _ n u m b e r , C o m m e n ) )  
             T s C a n d l e   =   P o s i t i o n T r a i l i n g S t o p O n C a n d l e ( T i c k e t P r i m o O r d i n e B u y ( m a g i c _ n u m b e r , C o m m e n ) , T y p e C a n d l e _ , i n d e x C a n d l e _ , T F C a n d l e , 0 . 0 ) ;  
       i f ( T i c k e t P r i m o O r d i n e S e l l ( m a g i c _ n u m b e r , C o m m e n ) )  
             T s C a n d l e   =   P o s i t i o n T r a i l i n g S t o p O n C a n d l e ( T i c k e t P r i m o O r d i n e S e l l ( m a g i c _ n u m b e r , C o m m e n ) , T y p e C a n d l e _ , i n d e x C a n d l e _ , T F C a n d l e , 0 . 0 ) ;  
     r e t u r n   T s C a n d l e ; }  
  
    
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                                         G e s t i o n e A T R ( )                                                   |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 b o o l   G e s t i o n e A T R ( )  
     {  
       b o o l   a = t r u e ;  
       i f ( ! F i l t e r _ A T R )   r e t u r n   a ;  
       i f ( F i l t e r _ A T R   & &   i A T R ( S y m b o l ( ) , p e r i o d A T R , A T R _ p e r i o d , 0 )   <   t h e s h o l d A T R )   a = f a l s e ;  
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
 / / |                                                   m y V o l u m e ( )                                                               |  
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
 	 c a p i t a l T o A l l o c a t e   =   	 c a p i t a l T o A l l o c a t e E A   >   0   ?   c a p i t a l T o A l l o c a t e E A   :   A c c o u n t B a l a n c e ( ) ;  
 }  
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
       r e t u r n   p r o f i t H i s t o r y   +   p r o f i t F l o a t i n g ;  
 }      
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                                     I n d i c a t o r s ( )                                                         |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 v o i d   I n d i c a t o r s ( )  
     {  
       c h a r   i n d e x = 1 ;  
  
                   C h a r t I n d i c a t o r A d d ( 0 , 0 , h a n d l e _ i C u s t o m M A F a s t ) ;  
                   C h a r t I n d i c a t o r A d d ( 0 , 0 , H a n d l e _ i C u s t o m Z i g Z a g ) ;  
                       / /   i n d e x   + + ;  
       i f ( O n C h a r t _ A T R )   i n t         i n d i c a t o r _ h a n d l e A T R = i A T R ( S y m b o l ( ) , p e r i o d A T R , A T R _ p e r i o d ) ;      
       }  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                           r e s e t I n d i c a t o r s ( )                                                         |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 v o i d   r e s e t I n d i c a t o r s ( )  
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
     }  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                                       H i s t o g r a m ( )                                                         |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 i n t   H i s t o g r a m ( v o i d )  
     {  
       i n t   k = 1 0 0 ;  
       d o u b l e   a r r [ 1 0 ] ;  
 / / - - -   c r e a t e   c h a r t  
       C H i s t o g r a m C h a r t   c h a r t ;  
       i f ( ! c h a r t . C r e a t e B i t m a p L a b e l ( " S a m p l e H i s t o g r a m C h a r t " , 1 0 , 1 0 , 6 0 0 , 4 5 0 ) )  
           {  
             P r i n t ( " E r r o r   c r e a t i n g   h i s t o g r a m   c h a r t :   " , G e t L a s t E r r o r ( ) ) ;  
             r e t u r n ( - 1 ) ;  
           }  
       i f ( A c c u m u l a t i v e )  
           {  
             c h a r t . A c c u m u l a t i v e ( ) ;  
             c h a r t . V S c a l e P a r a m s ( 2 0 * k * 1 0 , - 1 0 * k * 1 0 , 2 0 ) ;  
           }  
       e l s e  
             c h a r t . V S c a l e P a r a m s ( 2 0 * k , - 1 0 * k , 2 0 ) ;  
       c h a r t . S h o w V a l u e ( t r u e ) ;  
       c h a r t . S h o w S c a l e T o p ( f a l s e ) ;  
       c h a r t . S h o w S c a l e B o t t o m ( f a l s e ) ;  
       c h a r t . S h o w S c a l e R i g h t ( f a l s e ) ;  
       c h a r t . S h o w L e g e n d ( ) ;  
       f o r ( i n t   j = 0 ; j < 5 ; j + + )  
           {  
             f o r ( i n t   i = 0 ; i < 1 0 ; i + + )  
                 {  
                   k = - k ;  
                   i f ( k > 0 )  
                         a r r [ i ] = k * ( i + 1 0 - j ) ;  
                   e l s e  
                         a r r [ i ] = k * ( i + 1 0 - j ) / 2 ;  
                 }  
             c h a r t . S e r i e s A d d ( a r r , " I t e m " + I n t e g e r T o S t r i n g ( j ) ) ;  
           }  
 / / - - -   p l a y   w i t h   v a l u e s  
       w h i l e ( ! I s S t o p p e d ( ) )  
           {  
             i n t   i = r a n d ( ) % 5 ;  
             i n t   j = r a n d ( ) % 1 0 ;  
             k = r a n d ( ) % 3 0 0 0 - 1 0 0 0 ;  
             c h a r t . V a l u e U p d a t e ( i , j , k ) ;  
             S l e e p ( 2 0 0 ) ;  
           }  
 / / - - -   f i n i s h  
       c h a r t . D e s t r o y ( ) ;  
       r e t u r n ( 0 ) ;  
     }  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                                       C l e a r O b j ( )                                                           |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +      
 v o i d   C l e a r O b j ( )  
     {  
       i f ( O b j e c t F i n d ( 0 , P c o d e + " S o g l i a   S u p " ) > = 0 ) O b j e c t D e l e t e ( 0 , P c o d e + " S o g l i a   S u p " ) ;  
       i f ( O b j e c t F i n d ( 0 , P c o d e + " L i v   S u p " ) > = 0 ) O b j e c t D e l e t e ( 0 , P c o d e + " L i v   S u p " ) ;  
       i f ( O b j e c t F i n d ( 0 , P c o d e + " L i v   I n f " ) > = 0 ) O b j e c t D e l e t e ( 0 , P c o d e + " L i v   I n f " ) ;  
       i f ( O b j e c t F i n d ( 0 , P c o d e + " S o g l i a   I n f " ) > = 0 ) O b j e c t D e l e t e ( 0 , P c o d e + " S o g l i a   I n f " ) ;  
        
       i f ( O b j e c t F i n d ( 0 , P c o d e + " S o g l i a   S u p   " ) > = 0 ) O b j e c t D e l e t e ( 0 , P c o d e + " S o g l i a   S u p   " ) ;  
       i f ( O b j e c t F i n d ( 0 , P c o d e + " L i v   S u p   " ) > = 0 ) O b j e c t D e l e t e ( 0 , P c o d e + " L i v   S u p   " ) ;        
       i f ( O b j e c t F i n d ( 0 , P c o d e + " L i v   I n f   " ) > = 0 ) O b j e c t D e l e t e ( 0 , P c o d e + " L i v   I n f   " ) ;  
       i f ( O b j e c t F i n d ( 0 , P c o d e + " S o g l i a   I n f   " ) > = 0 ) O b j e c t D e l e t e ( 0 , P c o d e + " S o g l i a   I n f   " ) ;  
        
       i f ( O b j e c t F i n d ( 0 , P c o d e + " M a x   B u y   " ) > = 0 ) O b j e c t D e l e t e ( 0 , P c o d e + " M a x   B u y   " ) ;    
       i f ( O b j e c t F i n d ( 0 , P c o d e + " M i n   S e l l   " ) > = 0 ) O b j e c t D e l e t e ( 0 , P c o d e + " M i n   S e l l   " ) ;    
       i f ( O b j e c t F i n d ( 0 , P c o d e + " M a x   B u y " ) > = 0 ) O b j e c t D e l e t e ( 0 , P c o d e + " M a x   B u y " ) ;    
       i f ( O b j e c t F i n d ( 0 , P c o d e + " M i n   S e l l " ) > = 0 ) O b j e c t D e l e t e ( 0 , P c o d e + " M i n   S e l l " ) ;                
        
     }  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                             W R i t e L i n e N a m e ( )                                                           |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 v o i d   W R i t e L i n e N a m e ( )  
     {  
  
       d a t e t i m e   t i m e 2 , T i m e 5 [ 1 ] ;  
 / *  
       T i m e 5 [ 0 ] = 0 ;  
  
       C o p y T i m e ( S y m b o l ( ) , P e r i o d ( ) , 0 , 1 , T i m e 5 ) ;  
  
       i f ( ! M Q L I n f o I n t e g e r ( M Q L _ T E S T E R ) )  
           {  
             i f ( ! C h a r t G e t I n t e g e r ( 0 , C H A R T _ S H I F T , 0 ) ) { t i m e 2   =   T i m e 5 [ 0 ] - ( P e r i o d S e c o n d s ( P e r i o d ( ) ) * 1 3 ) ; }  
             e l s e { t i m e 2   =   T i m e 5 [ 0 ] + ( P e r i o d S e c o n d s ( P e r i o d ( ) ) * 1 3 ) ; }  
           }  
       e l s e  
           {  
             i f ( ! C h a r t G e t I n t e g e r ( 0 , C H A R T _ S H I F T , 0 ) ) { t i m e 2   =   T i m e 5 [ 0 ] - ( P e r i o d S e c o n d s ( P e r i o d ( ) ) * 1 3 ) ; }  
             e l s e { t i m e 2   =   T i m e 5 [ 0 ] + ( P e r i o d S e c o n d s ( P e r i o d ( ) ) ) ; }  
           } * /  
       t i m e 2 =   T i m e C u r r e n t ( ) ;  
       i f ( S H o w L i n e N a m e )  
           {  
             i f ( s o g l i a S u p ! = 0 )  
                 {  
                   i f ( O b j e c t F i n d ( 0 , P c o d e + " S o g l i a   S u p   " ) < 0 )  
                       {  
                         O b j e c t C r e a t e ( 0 , P c o d e + " S o g l i a   S u p   " ,   O B J _ T E X T , 0 , t i m e 2 , s o g l i a S u p ) ;  
                         O b j e c t S e t S t r i n g ( 0 , P c o d e + " S o g l i a   S u p   " , O B J P R O P _ T E X T , P c o d e + " S o g l i a   S u p   " + D o u b l e T o S t r i n g ( N o r m a l i z e D o u b l e ( s o g l i a S u p , D i g i t s ( ) ) , D i g i t s ( ) ) ) ;  
                         O b j e c t S e t S t r i n g ( 0 , P c o d e + " S o g l i a   S u p   " , O B J P R O P _ F O N T , " A r i a l " ) ;  
                         O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   S u p   " , O B J P R O P _ F O N T S I Z E , 8 ) ;  
                         O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   S u p   " , O B J P R O P _ B A C K , D r a w B a c k g r o u n d ) ;  
                         O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   S u p   " , O B J P R O P _ S E L E C T A B L E , ! D i s a b l e S e l e c t i o n ) ;  
                         O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   S u p   " , O B J P R O P _ H I D D E N , t r u e ) ;  
                       }  
                   e l s e  
                       {  
                         O b j e c t M o v e ( 0 , P c o d e + " S o g l i a   S u p   " , 0 , t i m e 2 , s o g l i a S u p ) ;  
                         O b j e c t S e t S t r i n g ( 0 , P c o d e + " S o g l i a   S u p   " , O B J P R O P _ T E X T , P c o d e + " S o g l i a   S u p   " + D o u b l e T o S t r i n g ( N o r m a l i z e D o u b l e ( s o g l i a S u p , D i g i t s ( ) ) , D i g i t s ( ) ) ) ;  
                       }  
                   O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   S u p   " , O B J P R O P _ C O L O R , c o l o r e s e l l ) ;  
                 }  
  
  
             i f ( s o g l i a I n f ! = 0 )  
                 {  
                   i f ( O b j e c t F i n d ( 0 , P c o d e + " S o g l i a   I n f   " ) < 0 )  
                       {  
                         O b j e c t C r e a t e ( 0 , P c o d e + " S o g l i a   I n f   " ,   O B J _ T E X T , 0 , t i m e 2 , s o g l i a I n f ) ;  
                         O b j e c t S e t S t r i n g ( 0 , P c o d e + " S o g l i a   I n f   " , O B J P R O P _ T E X T , P c o d e + " S o g l i a   I n f   " + D o u b l e T o S t r i n g ( N o r m a l i z e D o u b l e ( s o g l i a I n f , D i g i t s ( ) ) , D i g i t s ( ) ) ) ;  
                         O b j e c t S e t S t r i n g ( 0 , P c o d e + " S o g l i a   I n f   " , O B J P R O P _ F O N T , " A r i a l " ) ;  
                         O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   I n f   " , O B J P R O P _ F O N T S I Z E , 8 ) ;  
                         O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   I n f   " , O B J P R O P _ B A C K , D r a w B a c k g r o u n d ) ;  
                         O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   I n f   " , O B J P R O P _ S E L E C T A B L E , ! D i s a b l e S e l e c t i o n ) ;  
                         O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   I n f   " , O B J P R O P _ H I D D E N , t r u e ) ;  
                       }  
                   e l s e  
                       {  
                         O b j e c t M o v e ( 0 , P c o d e + " S o g l i a   I n f   " , 0 , t i m e 2 , s o g l i a I n f ) ;  
                         O b j e c t S e t S t r i n g ( 0 , P c o d e + " S o g l i a   I n f   " , O B J P R O P _ T E X T , P c o d e + " S o g l i a   I n f   " + D o u b l e T o S t r i n g ( N o r m a l i z e D o u b l e ( s o g l i a I n f , D i g i t s ( ) ) , D i g i t s ( ) ) ) ;  
                       }  
                   O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   I n f   " , O B J P R O P _ C O L O R , c o l o r e b u y ) ;  
                 }  
  
  
             i f ( s o g l i a b u y c o n s ! = 0 )  
                 {  
                   i f ( O b j e c t F i n d ( 0 , P c o d e + " M a x   B u y   " ) < 0 )  
                       {  
                         O b j e c t C r e a t e ( 0 , P c o d e + " M a x   B u y   " ,   O B J _ T E X T , 0 , t i m e 2 , s o g l i a b u y c o n s ) ;  
                         O b j e c t S e t S t r i n g ( 0 , P c o d e + " M a x   B u y   " , O B J P R O P _ T E X T , P c o d e + " M a x   B u y   " + D o u b l e T o S t r i n g ( N o r m a l i z e D o u b l e ( s o g l i a b u y c o n s , D i g i t s ( ) ) , D i g i t s ( ) ) ) ;  
                         O b j e c t S e t S t r i n g ( 0 , P c o d e + " M a x   B u y   " , O B J P R O P _ F O N T , " A r i a l " ) ;  
                         O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M a x   B u y   " , O B J P R O P _ F O N T S I Z E , 8 ) ;  
                         O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M a x   B u y   " , O B J P R O P _ B A C K , D r a w B a c k g r o u n d ) ;  
                         O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M a x   B u y   " , O B J P R O P _ S E L E C T A B L E , ! D i s a b l e S e l e c t i o n ) ;  
                         O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M a x   B u y   " , O B J P R O P _ H I D D E N , t r u e ) ;  
                       }  
                   e l s e  
                       {  
                         O b j e c t M o v e ( 0 , P c o d e + " M a x   B u y   " , 0 , t i m e 2 , s o g l i a b u y c o n s ) ;  
                         O b j e c t S e t S t r i n g ( 0 , P c o d e + " M a x   B u y   " , O B J P R O P _ T E X T , P c o d e + " M a x   B u y   " + D o u b l e T o S t r i n g ( N o r m a l i z e D o u b l e ( s o g l i a b u y c o n s , D i g i t s ( ) ) , D i g i t s ( ) ) ) ;  
                       }  
                   O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M a x   B u y   " , O B J P R O P _ C O L O R , c o l o r e b u y ) ;  
                 }  
    
             i f ( s o g l i a s e l l c o n s ! = 0 )  
                 {  
                   i f ( O b j e c t F i n d ( 0 , P c o d e + " M i n   S e l l   " ) < 0 )  
                       {  
                         O b j e c t C r e a t e ( 0 , P c o d e + " M i n   S e l l   " ,   O B J _ T E X T , 0 , t i m e 2 , s o g l i a s e l l c o n s ) ;  
                         O b j e c t S e t S t r i n g ( 0 , P c o d e + " M i n   S e l l   " , O B J P R O P _ T E X T , P c o d e + " M i n   S e l l   " + D o u b l e T o S t r i n g ( N o r m a l i z e D o u b l e ( s o g l i a s e l l c o n s , D i g i t s ( ) ) , D i g i t s ( ) ) ) ;  
                         O b j e c t S e t S t r i n g ( 0 , P c o d e + " M i n   S e l l   " , O B J P R O P _ F O N T , " A r i a l " ) ;  
                         O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M i n   S e l l   " , O B J P R O P _ F O N T S I Z E , 8 ) ;  
                         O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M i n   S e l l   " , O B J P R O P _ B A C K , D r a w B a c k g r o u n d ) ;  
                         O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M i n   S e l l   " , O B J P R O P _ S E L E C T A B L E , ! D i s a b l e S e l e c t i o n ) ;  
                         O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M i n   S e l l   " , O B J P R O P _ H I D D E N , t r u e ) ;  
                       }  
                   e l s e  
                       {  
                         O b j e c t M o v e ( 0 , P c o d e + " M i n   S e l l   " , 0 , t i m e 2 , s o g l i a s e l l c o n s ) ;  
                         O b j e c t S e t S t r i n g ( 0 , P c o d e + " M i n   S e l l   " , O B J P R O P _ T E X T , P c o d e + " M i n   S e l l   " + D o u b l e T o S t r i n g ( N o r m a l i z e D o u b l e ( s o g l i a s e l l c o n s , D i g i t s ( ) ) , D i g i t s ( ) ) ) ;  
                       }  
                   O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M i n   S e l l   " , O B J P R O P _ C O L O R , c o l o r e s e l l ) ;  
                 }    
                  
 } }      
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                         d r a w H o r i z o n t a l L i n e ( )                                                     |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 v o i d   d r a w H o r i z o n t a l L e v e l ( )  
     {  
       d a t e t i m e   T i m e 5 [ 1 ] ;  
       C o p y T i m e ( S y m b o l ( ) , P E R I O D _ D 1 , 0 , 1 , T i m e 5 ) ;  
  
       i f ( s o g l i a S u p ! = 0 )  
           {  
             i f ( O b j e c t F i n d ( 0 , P c o d e + " S o g l i a   S u p " ) < 0 )  
                   O b j e c t C r e a t e ( 0 , P c o d e + " S o g l i a   S u p " ,   O B J _ H L I N E ,   0 ,   T i m e 5 [ 0 ] ,   s o g l i a S u p ) ;  
             e l s e  
                   O b j e c t M o v e ( 0 , P c o d e + " S o g l i a   S u p " , 0 , T i m e 5 [ 0 ] , s o g l i a S u p ) ;  
  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   S u p " ,   O B J P R O P _ W I D T H ,   S p e s s o r e l i n e a ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   S u p " ,   O B J P R O P _ C O L O R ,   c o l o r e s e l l ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   S u p " ,   O B J P R O P _ S T Y L E ,   t i p o d i l i n e a ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   S u p " ,   O B J P R O P _ B A C K ,   D R a w B a c k g r o u n d ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   S u p " ,   O B J P R O P _ S E L E C T A B L E ,   ! D I s a b l e S e l e c t i o n ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   S u p " ,   O B J P R O P _ H I D D E N ,   t r u e ) ;  
           }  
  
  
       i f ( s o g l i a I n f ! = 0 )  
           {  
             i f ( O b j e c t F i n d ( 0 , P c o d e + " S o g l i a   I n f " ) < 0 )  
                   O b j e c t C r e a t e ( 0 , P c o d e + " S o g l i a   I n f " ,   O B J _ H L I N E ,   0 ,   T i m e 5 [ 0 ] ,   s o g l i a I n f ) ;  
             e l s e  
                   O b j e c t M o v e ( 0 , P c o d e + " S o g l i a   I n f " , 0 , T i m e 5 [ 0 ] , s o g l i a I n f ) ;  
  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   I n f " ,   O B J P R O P _ W I D T H ,   S p e s s o r e l i n e a ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   I n f " ,   O B J P R O P _ C O L O R ,   c o l o r e b u y ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   I n f " ,   O B J P R O P _ S T Y L E ,   t i p o d i l i n e a ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   I n f " ,   O B J P R O P _ B A C K ,   D R a w B a c k g r o u n d ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   I n f " ,   O B J P R O P _ S E L E C T A B L E ,   ! D I s a b l e S e l e c t i o n ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   I n f " ,   O B J P R O P _ H I D D E N ,   t r u e ) ;  
           }  
            
            
       i f ( s o g l i a b u y c o n s ! = 0 )  
           {  
             i f ( O b j e c t F i n d ( 0 , P c o d e + " M a x   B u y " ) < 0 )  
                   O b j e c t C r e a t e ( 0 , P c o d e + " M a x   B u y " ,   O B J _ H L I N E ,   0 ,   T i m e 5 [ 0 ] ,   s o g l i a b u y c o n s ) ;  
             e l s e  
                   O b j e c t M o v e ( 0 , P c o d e + " M a x   B u y " , 0 , T i m e 5 [ 0 ] , s o g l i a b u y c o n s ) ;  
  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M a x   B u y " ,   O B J P R O P _ W I D T H ,   S p e s s o r e l i n e a ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M a x   B u y " ,   O B J P R O P _ C O L O R ,   c o l o r e b u y ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M a x   B u y " ,   O B J P R O P _ S T Y L E ,   t i p o d i l i n e a ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M a x   B u y " ,   O B J P R O P _ B A C K ,   D R a w B a c k g r o u n d ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M a x   B u y " ,   O B J P R O P _ S E L E C T A B L E ,   ! D I s a b l e S e l e c t i o n ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M a x   B u y " ,   O B J P R O P _ H I D D E N ,   t r u e ) ;  
           }  
  
  
       i f ( s o g l i a s e l l c o n s ! = 0 )  
           {  
             i f ( O b j e c t F i n d ( 0 , P c o d e + " M i n   S e l l " ) < 0 )  
                   O b j e c t C r e a t e ( 0 , P c o d e + " M i n   S e l l " ,   O B J _ H L I N E ,   0 ,   T i m e 5 [ 0 ] ,   s o g l i a s e l l c o n s ) ;  
             e l s e  
                   O b j e c t M o v e ( 0 , P c o d e + " M i n   S e l l " , 0 , T i m e 5 [ 0 ] , s o g l i a s e l l c o n s ) ;  
  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M i n   S e l l " ,   O B J P R O P _ W I D T H ,   S p e s s o r e l i n e a ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M i n   S e l l " ,   O B J P R O P _ C O L O R ,   c o l o r e s e l l ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M i n   S e l l " ,   O B J P R O P _ S T Y L E ,   t i p o d i l i n e a ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M i n   S e l l " ,   O B J P R O P _ B A C K ,   D R a w B a c k g r o u n d ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M i n   S e l l " ,   O B J P R O P _ S E L E C T A B L E ,   ! D I s a b l e S e l e c t i o n ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M i n   S e l l " ,   O B J P R O P _ H I D D E N ,   t r u e ) ;  
           }            
            
 }  
  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                         D R a w R e c t a n g l e L i n e ( )                                                       |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 v o i d   D R a w R e c t a n g l e L i n e ( d a t e t i m e   t i m e p i c c o a l t o , d a t e t i m e   t i m e p i c c o b a s s o )  
     {  
       d a t e t i m e   t i m e 1 , t i m e 2 , t i m e 3 ;  
  
       t i m e 1   =   t i m e p i c c o a l t o ;    
  
       t i m e 2   =   T i m e C u r r e n t ( ) ;  
  
       t i m e 3   =   t i m e p i c c o b a s s o ;  
  
       i f ( s o g l i a S u p ! = 0 )  
           {  
             i f ( O b j e c t F i n d ( 0 , P c o d e + " S o g l i a   S u p " ) < 0 )  
                   O b j e c t C r e a t e ( 0 , P c o d e + " S o g l i a   S u p " ,   O B J _ R E C T A N G L E ,   0 ,   t i m e 1 ,   s o g l i a S u p ,   t i m e 2 ,   s o g l i a S u p ) ;  
             e l s e  
                 {  
                   O b j e c t M o v e ( 0 , P c o d e + " S o g l i a   S u p " , 0 , t i m e 1 , s o g l i a S u p ) ;  
                   O b j e c t M o v e ( 0 , P c o d e + " S o g l i a   S u p " , 1 , t i m e 2 , s o g l i a S u p ) ;  
                 }  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   S u p " ,   O B J P R O P _ W I D T H ,   S p e s s o r e l i n e a ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   S u p " ,   O B J P R O P _ C O L O R ,   c o l o r e s e l l ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   S u p " ,   O B J P R O P _ S T Y L E ,   t i p o d i l i n e a ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   S u p " ,   O B J P R O P _ B A C K ,   D R a w B a c k g r o u n d ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   S u p " ,   O B J P R O P _ S E L E C T A B L E ,   ! D I s a b l e S e l e c t i o n ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   S u p " ,   O B J P R O P _ H I D D E N ,   t r u e ) ;  
           }  
  
  
       i f ( s o g l i a I n f ! = 0 )  
           {  
             i f ( O b j e c t F i n d ( 0 , P c o d e + " S o g l i a   I n f " ) < 0 )  
                   O b j e c t C r e a t e ( 0 , P c o d e + " S o g l i a   I n f " ,   O B J _ R E C T A N G L E ,   0 ,   t i m e 3 ,   s o g l i a I n f ,   t i m e 2 ,   s o g l i a I n f ) ;  
             e l s e  
                 {  
                   O b j e c t M o v e ( 0 , P c o d e + " S o g l i a   I n f " , 0 , t i m e 3 , s o g l i a I n f ) ;  
                   O b j e c t M o v e ( 0 , P c o d e + " S o g l i a   I n f " , 1 , t i m e 2 , s o g l i a I n f ) ;  
                 }  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   I n f " ,   O B J P R O P _ W I D T H ,   S p e s s o r e l i n e a ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   I n f " ,   O B J P R O P _ C O L O R ,   c o l o r e b u y ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   I n f " ,   O B J P R O P _ S T Y L E ,   t i p o d i l i n e a ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   I n f " ,   O B J P R O P _ B A C K ,   D R a w B a c k g r o u n d ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   I n f " ,   O B J P R O P _ S E L E C T A B L E ,   ! D I s a b l e S e l e c t i o n ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " S o g l i a   I n f " ,   O B J P R O P _ H I D D E N ,   t r u e ) ;  
           }  
            
  
  
  
       i f ( s o g l i a b u y c o n s ! = 0 )  
           {  
             i f ( O b j e c t F i n d ( 0 , P c o d e + " M a x   B u y " ) < 0 )  
                   O b j e c t C r e a t e ( 0 , P c o d e + " M a x   B u y " ,   O B J _ R E C T A N G L E ,   0 ,   t i m e 3 ,   s o g l i a b u y c o n s ,   t i m e 2 ,   s o g l i a b u y c o n s ) ;  
             e l s e  
                 {  
                   O b j e c t M o v e ( 0 , P c o d e + " M a x   B u y " , 0 , t i m e 3 , s o g l i a b u y c o n s ) ;  
                   O b j e c t M o v e ( 0 , P c o d e + " M a x   B u y " , 1 , t i m e 2 , s o g l i a b u y c o n s ) ;  
                 }  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M a x   B u y " ,   O B J P R O P _ W I D T H ,   S p e s s o r e l i n e a ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M a x   B u y " ,   O B J P R O P _ C O L O R ,   c o l o r e b u y ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M a x   B u y " ,   O B J P R O P _ S T Y L E ,   t i p o d i l i n e a ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M a x   B u y " ,   O B J P R O P _ B A C K ,   D R a w B a c k g r o u n d ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M a x   B u y " ,   O B J P R O P _ S E L E C T A B L E ,   ! D I s a b l e S e l e c t i o n ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M a x   B u y " ,   O B J P R O P _ H I D D E N ,   t r u e ) ;  
           }  
      
  
  
       i f ( s o g l i a s e l l c o n s ! = 0 )  
           {  
             i f ( O b j e c t F i n d ( 0 , P c o d e + " M i n   S e l l " ) < 0 )  
                   O b j e c t C r e a t e ( 0 , P c o d e + " M i n   S e l l " ,   O B J _ R E C T A N G L E ,   0 ,   t i m e 3 ,   s o g l i a s e l l c o n s ,   t i m e 2 ,   s o g l i a s e l l c o n s ) ;  
             e l s e  
                 {  
                   O b j e c t M o v e ( 0 , P c o d e + " M i n   S e l l " , 0 , t i m e 3 , s o g l i a s e l l c o n s ) ;  
                   O b j e c t M o v e ( 0 , P c o d e + " M i n   S e l l " , 1 , t i m e 2 , s o g l i a s e l l c o n s ) ;  
                 }  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M i n   S e l l " ,   O B J P R O P _ W I D T H ,   S p e s s o r e l i n e a ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M i n   S e l l " ,   O B J P R O P _ C O L O R ,   c o l o r e s e l l ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M i n   S e l l " ,   O B J P R O P _ S T Y L E ,   t i p o d i l i n e a ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M i n   S e l l " ,   O B J P R O P _ B A C K ,   D R a w B a c k g r o u n d ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M i n   S e l l " ,   O B J P R O P _ S E L E C T A B L E ,   ! D I s a b l e S e l e c t i o n ) ;  
             O b j e c t S e t I n t e g e r ( 0 , P c o d e + " M i n   S e l l " ,   O B J P R O P _ H I D D E N ,   t r u e ) ;  
           }      
            
           }      
  
  
      
      
      
      
     