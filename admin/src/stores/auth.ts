import { create } from 'zustand'
import { persist } from 'zustand/middleware'
import type { AdminInfo } from '@/types/api'

interface AuthState {
  token: string | null
  adminInfo: AdminInfo | null
  login: (token: string, adminInfo: AdminInfo) => void
  logout: () => void
  isAuthenticated: () => boolean
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set, get) => ({
      token: null,
      adminInfo: null,
      login: (token, adminInfo) => set({ token, adminInfo }),
      logout: () => set({ token: null, adminInfo: null }),
      isAuthenticated: () => !!get().token,
    }),
    { name: 'admin-auth' }
  )
)
