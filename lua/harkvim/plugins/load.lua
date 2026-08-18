return {
  plugin = function (self, plugin)
    local o = { plugin = plugin }
    setmetatable(o, self)
    self.__index = self
    return o
  end,

  immediately = function (self)
    vim.cmd.packadd(self.plugin)
  end,

  immediately_after = function (self, event, opts)
    local group = vim.api.nvim_create_augroup(
      "harkvim.plugins.load->" .. self.plugin,
      { clear = true }
    )

    vim.api.nvim_create_autocmd(event, vim.tbl_extend('error', opts or {}, {
      group = group,
      callback = function ()
        self:immediately()
        vim.api.nvim_del_augroup_by_id(group)
      end,
      once = true,
    }))
  end,

  soon = function (self)
    vim.schedule(function ()
      self:immediately()
    end)
  end,

  soon_after = function (self, event, opts)
    local group = vim.api.nvim_create_augroup(
      "harkvim.plugins.load->" .. self.plugin,
      { clear = true }
    )

    vim.api.nvim_create_autocmd(event, vim.tbl_extend('error', opts or {}, {
      group = group,
      callback = function ()
        self:soon()
        vim.api.nvim_del_augroup_by_id(group)
      end,
      once = true,
    }))
  end,
}
