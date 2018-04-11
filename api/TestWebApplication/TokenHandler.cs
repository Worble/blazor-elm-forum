using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using Microsoft.IdentityModel.Tokens;

namespace TestWebApplication
{
    public class TokenHandler
    {
        public static string GenerateJwt(string id)
        {
            var claims = new[]
            {
                new Claim(ClaimTypes.NameIdentifier, id)
            };

            var secret = Environment.GetEnvironmentVariable("SECRET_KEY");
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secret));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var token = new JwtSecurityToken(
                issuer: "yourdomain.com",
                audience: "yourdomain.com",
                claims: claims,
                expires: DateTime.Now.AddMinutes(30),
                signingCredentials: creds);

            return new JwtSecurityTokenHandler().WriteToken(token);
        }

        public static bool JwtValid(string id, out string guid)
        {
            var secret = Environment.GetEnvironmentVariable("SECRET_KEY");
            TokenValidationParameters validationParameters =
                new TokenValidationParameters
                {
                    ValidateIssuer = true,
                    ValidateAudience = true,
                    ValidateLifetime = true,
                    ValidateIssuerSigningKey = true,
                    ValidIssuer = "yourdomain.com",
                    ValidAudience = "yourdomain.com",
                    IssuerSigningKey = new SymmetricSecurityKey(
                        Encoding.UTF8.GetBytes(secret))
                };

            SecurityToken validatedToken;
            JwtSecurityTokenHandler handler = new JwtSecurityTokenHandler();
            try
            {
                var user = handler.ValidateToken(id, validationParameters, out validatedToken);
                guid = user.Claims.FirstOrDefault(e => e.Type == ClaimTypes.NameIdentifier).Value;
            }
            catch (SecurityTokenException)
            {
                guid = string.Empty;
                return false;
            }
            
            return validatedToken != null;
        }
    }
}
