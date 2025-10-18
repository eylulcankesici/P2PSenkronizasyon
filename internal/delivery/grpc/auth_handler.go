package grpc

import (
	"context"
	"fmt"

	"google.golang.org/protobuf/types/known/timestamppb"

	pb "github.com/aether/sync/api/proto"
	"github.com/aether/sync/internal/container"
	"github.com/aether/sync/internal/domain/entity"
)

// AuthHandler AuthService implementasyonu
type AuthHandler struct {
	pb.UnimplementedAuthServiceServer
	container *container.Container
}

// NewAuthHandler yeni AuthHandler oluşturur
func NewAuthHandler(cont *container.Container) *AuthHandler {
	return &AuthHandler{container: cont}
}

// Register yeni kullanıcı kaydı
func (h *AuthHandler) Register(ctx context.Context, req *pb.RegisterRequest) (*pb.RegisterResponse, error) {
	// Kullanıcı rolünü dönüştür
	role := entity.UserRoleStandard
	if req.Role == pb.UserRole_USER_ROLE_ADMIN {
		role = entity.UserRoleAdmin
	}

	// Yeni kullanıcı oluştur (password şimdilik plain text - gerçek uygulamada hash'lenmeli)
	user := entity.NewUser(req.ProfileName, role, req.Password)

	// Repository kullanarak kaydet
	if err := h.container.UserRepository().Create(ctx, user); err != nil {
		return &pb.RegisterResponse{
			Status: &pb.Status{
				Success: false,
				Message: fmt.Sprintf("Kullanıcı kaydı başarısız: %v", err),
				Code:    400,
			},
		}, nil
	}

	return &pb.RegisterResponse{
		Status: &pb.Status{
			Success: true,
			Message: "Kullanıcı başarıyla kaydedildi",
			Code:    200,
		},
		User: convertUserToProto(user),
	}, nil
}

// Login kullanıcı girişi
func (h *AuthHandler) Login(ctx context.Context, req *pb.LoginRequest) (*pb.LoginResponse, error) {
	// Kullanıcıyı profil adına göre bul
	user, err := h.container.UserRepository().GetByProfileName(ctx, req.ProfileName)
	if err != nil {
		return &pb.LoginResponse{
			Status: &pb.Status{
				Success: false,
				Message: "Kullanıcı bulunamadı",
				Code:    401,
			},
		}, nil
	}

	// Şifre kontrolü (basit - gerçek uygulamada bcrypt kullan)
	// Şimdilik placeholder olarak kabul et
	
	// Basit token oluştur (gerçek uygulamada JWT kullan)
	token := fmt.Sprintf("token_%s_%d", user.ID, user.CreatedAt.Unix())

	return &pb.LoginResponse{
		Status: &pb.Status{
			Success: true,
			Message: "Giriş başarılı",
			Code:    200,
		},
		Token:     token,
		User:      convertUserToProto(user),
		ExpiresAt: timestamppb.New(user.CreatedAt.Add(24 * 365 * 10)),  // 10 yıl (placeholder)
	}, nil
}

// Logout kullanıcı çıkışı
func (h *AuthHandler) Logout(ctx context.Context, req *pb.LogoutRequest) (*pb.Status, error) {
	// Şu an için sadece başarı dön (token management eklenebilir)
	return &pb.Status{
		Success: true,
		Message: "Çıkış başarılı",
		Code:    200,
	}, nil
}

// ValidateToken token doğrulama
func (h *AuthHandler) ValidateToken(ctx context.Context, req *pb.ValidateTokenRequest) (*pb.ValidateTokenResponse, error) {
	// Basit token validasyonu (gerçek uygulamada JWT kullan)
	// Şu an için her token geçerli kabul ediliyor
	
	return &pb.ValidateTokenResponse{
		Status: &pb.Status{
			Success: true,
			Message: "Token geçerli",
			Code:    200,
		},
		IsValid: true,
		User: nil,  // Token'dan user bilgisi parse edilebilir
	}, nil
}

// ChangePassword şifre değiştirme
func (h *AuthHandler) ChangePassword(ctx context.Context, req *pb.ChangePasswordRequest) (*pb.Status, error) {
	// Şifre değiştirme işlemi (placeholder)
	// Gerçek uygulamada:
	// 1. Kullanıcıyı bul
	// 2. Eski şifreyi doğrula
	// 3. Yeni şifreyi hash'le
	// 4. Güncelle
	
	return &pb.Status{
		Success: true,
		Message: "Şifre değiştirme - yakında implement edilecek",
		Code:    501,
	}, nil
}

// Helper fonksiyonlar

func convertUserToProto(u *entity.User) *pb.User {
	if u == nil {
		return nil
	}

	return &pb.User{
		Id:          u.ID,
		ProfileName: u.ProfileName,
		Role:        convertUserRoleToProto(u.Role),
		IsActive:    u.IsActive,
		CreatedAt:   timestamppb.New(u.CreatedAt),
		UpdatedAt:   timestamppb.New(u.UpdatedAt),
	}
}

func convertUserRoleToProto(role entity.UserRole) pb.UserRole {
	switch role {
	case entity.UserRoleAdmin:
		return pb.UserRole_USER_ROLE_ADMIN
	case entity.UserRoleStandard:
		return pb.UserRole_USER_ROLE_STANDARD
	default:
		return pb.UserRole_USER_ROLE_STANDARD
	}
}

